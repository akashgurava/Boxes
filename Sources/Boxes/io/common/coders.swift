import Foundation

protocol CodableEncoder {
    func encode<T: Encodable>(_ object: T) throws -> Data
}

protocol CodableDecoder {
    func decode<T: Decodable>(_ type: T.Type, from: Data) throws -> T
}

protocol FileIOCoder {
    var url: URL { get }
    var encoder: CodableEncoder { get }
    var decoder: CodableDecoder { get }

    init(path: String)
}

extension FileIOCoder {
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

    func write(_ box: Box) throws {
        try writeMeta(box.meta)
    }

    func readMeta() throws -> BoxMeta {
        var readingFile: FileHandle
        do {
            readingFile = try FileHandle(forReadingFrom: url)
        } catch {
            throw BoxError.boxOpenError(.read, error)
        }
        do {
            return try decoder.decode(
                BoxMeta.self,
                from: try readingFile.readToEnd().unsafelyUnwrapped)
        } catch BoxError.boxMetaDecodeError(let error) {
            throw BoxError.boxMetaDecodeError(error)
        } catch {
            throw BoxError.boxMetaDecodeError(error)
        }
    }

    func read() throws -> Box {
        let meta = try readMeta()
        return Box(meta: meta)
    }

}
