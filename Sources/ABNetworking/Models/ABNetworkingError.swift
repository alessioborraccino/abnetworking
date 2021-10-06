import Foundation

public enum ABNetworkingError: Error, LocalizedError {
    case noResourceFound
    case receivedNonHttpResponse
    case couldNotParseResult(Error)
    case urlSessionError(Error)
}

extension ABNetworkingError {
    public var errorDescription: String? {
        switch self {
        case .noResourceFound:
            return "Invalid url"
        case .receivedNonHttpResponse:
            return "Response is not http"
        case .couldNotParseResult(let error):
            return "Error while parsing result: \(error.localizedDescription)"
        case .urlSessionError(let error):
            return "URL session error: \(error.localizedDescription)"
        }
    }
}
