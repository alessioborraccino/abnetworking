import Foundation

public enum ABNetworkingError: Error {
    case noResourceFound
    case couldNotParseResult(Error)
    case receivedNonHttpResponse
    case urlSessionError(Error)
}
