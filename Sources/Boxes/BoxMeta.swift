
import Foundation

enum BoxOpenMode: String {
    case read, write
}

struct BoxMeta: Codable, Equatable {
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
}
