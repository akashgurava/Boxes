import Foundation
import TLVCoding

extension TLVEncoder: CodableEncoder {
    func encodeFromObject<T: Encodable>(_ object: T) throws -> Data {
        try encode(object)
    }
}

extension TLVDecoder: CodableDecoder {
    func decodeToObject<T: Decodable>(_ type: T.Type, from: Data) throws -> T {
        try decode(T.self, from: from)
    }
}


class TlvIOCoder: FileIOCoder {
    let path: String
    let url: URL
    
    let encoder: CodableEncoder = TLVEncoder()
    let decoder: CodableDecoder = TLVDecoder()
    
    required init(path: String) {
        FileManager().createFile(atPath: path, contents: .none)
        
        self.path = path
        self.url = URL(fileURLWithPath: path)
    }
}
