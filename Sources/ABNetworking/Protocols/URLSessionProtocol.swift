import Foundation

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}


@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(macCatalyst 15.0, *)
extension URLSession: URLSessionProtocol {
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
