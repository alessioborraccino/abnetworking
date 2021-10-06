import Foundation

public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case get = "GET"
    case delete = "DELETE"
}

public protocol APIRequest {
    var endpoint: APIEndpoint { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

public extension APIRequest {
    var body: Data? {
        return nil
    }

    var headers: [String: String]? {
        return nil
    }
}

public extension APIRequest {

    private var defaultHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    var jsonUrlRequest: URLRequest {
        guard let url = endpoint.url else {
            fatalError("It should always create a url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        (headers ?? defaultHeaders).forEach { entry in
            request.addValue(entry.value, forHTTPHeaderField: entry.key)
        }
        return request
    }
}
