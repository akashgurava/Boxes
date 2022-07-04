import Foundation
import SwiftBSON

extension BSONEncoder: CodableEncoder {
    func encodeFromObject<T>(_ object: T) throws -> Data where T: Encodable {
        try encode(object).toData()
    }
}

extension BSONDecoder: CodableDecoder {
    func decodeToObject<T: Decodable>(_ type: T.Type, from: Data) throws -> T {
        try decode(T.self, from: BSONDocument(fromBSON: from))
    }
}


class BsonIOCoder: FileIOCoder {
    let path: String
    let url: URL

    let encoder: CodableEncoder = BSONEncoder()
    let decoder: CodableDecoder = BSONDecoder()

    required init(path: String) {
        FileManager().createFile(atPath: path, contents: .none)

        self.path = path
        self.url = URL(fileURLWithPath: path)
    }
}
