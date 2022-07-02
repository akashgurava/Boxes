import Foundation

enum BoxError: LocalizedError {
    case unknown

    case boxOpenError(_ mode: BoxOpenMode, _ reason: Error)
    case invalidColumnNames(_ errCols: [String])

    case boxMetaDecodeError(_ reason: Error)
    case boxMetaEncodeError(_ reason: Error)

    public var errorDescription: String? {
        switch self {
        case .unknown:
            return """
            Unknown failure.
            """
        case .boxOpenError(let mode, let reason):
            return """
            Could not open box. Mode:\(mode). Reason: \(reason).
            """

        case .invalidColumnNames(let errCols):
            return """
            Invalid column names. Error Columns: \(errCols.joined(separator: ",")).
            """

        case .boxMetaDecodeError(let reason):
            return """
            Could not decode box metadata. Reason: \(reason).
            """

        case .boxMetaEncodeError(let reason):
            return """
            Could not encode box metadata. Reason: \(reason).
            """
        }
    }
}
