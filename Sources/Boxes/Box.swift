import BinaryCodable
import Foundation

enum BoxOpenMode: String {
    case read, write
}

struct BoxMeta: BinaryCodable, Equatable {
    static let capacity: Int = 100_000_000
    static let maxColNameLen: Int = 50
    static let metaDelimiter: String = ""

    let rowCount: UInt64
    let columnCount: UInt64
    let columns: [String]

    public init(columns: [String]) throws {
        rowCount = 0
        columnCount = UInt64(columns.count)
        let errCols = columns.filter { $0.hasSuffix(" ") || $0.hasPrefix(" ") }
        if (!errCols.isEmpty) {
            throw BoxError.invalidColumnNames(errCols)
        }
        self.columns = columns
    }

    init(from decoder: BinaryDecoder) throws {
        var container = decoder.container(maxLength: 10000)

        do {
            rowCount = try container.decode(UInt64.self)
            columnCount = try container.decode(UInt64.self)
            columns = try (1...columnCount).map { i in
                var colContainer = container.nestedContainer(maxLength: Self.maxColNameLen)
                return try colContainer.decodeString(encoding: .utf8, terminator: nil).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            throw BoxError.boxMetaDecodeError(error)
        }
    }

    func encode(to encoder: BinaryEncoder) throws {
        var container = encoder.container()
        do {
            try container.encode(rowCount)
            try container.encode(columnCount)
            for column in columns {
                try container.encode(
                    column.padding(toLength: Self.maxColNameLen, withPad: " ", startingAt: 0),
                    encoding: .utf8, terminator: nil)
            }
        } catch {
            throw BoxError.boxMetaEncodeError(error)
        }
    }
}

class Box {
    private let path: String
    private let url: URL

    private let encoder: BinaryDataEncoder
    private let decoder: BinaryDataDecoder

    init(path: String) {
        FileManager().createFile(atPath: path, contents: .none)

        self.path = path
        self.url = URL(fileURLWithPath: path)
        encoder = BinaryDataEncoder()
        decoder = BinaryDataDecoder()
    }

    func writeMeta(_ meta: BoxMeta) throws {
        var writingFile: FileHandle
        do {
            writingFile = try FileHandle(forWritingTo: url)
        } catch {
            throw BoxError.boxOpenError(.write, error)
        }

        do {
            writingFile.write(try encoder.encode(meta))
        } catch BoxError.boxMetaEncodeError(let error) {
            throw BoxError.boxMetaEncodeError(error)
        } catch {
            throw BoxError.boxMetaEncodeError(error)
        }
    }

    func readMeta() throws -> BoxMeta {
        var readingFile: FileHandle
        do {
            readingFile = try FileHandle(forReadingFrom: url)
        } catch {
            throw BoxError.boxOpenError(.write, error)
        }
        do {
            return try decoder.decode(
                BoxMeta.self,
                from: try readingFile.read(upToCount: BoxMeta.capacity)!)
        } catch BoxError.boxMetaDecodeError(let error) {
            throw BoxError.boxMetaDecodeError(error)
        } catch {
            throw BoxError.boxMetaDecodeError(error)
        }
    }
}
