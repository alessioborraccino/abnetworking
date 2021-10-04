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
}

public extension APIRequest {
    var body: Data? {
        return nil
    }
}

public extension APIRequest {
    
    var jsonUrlRequest: URLRequest {
        guard let url = endpoint.url else {
            fatalError("It should always create a url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
