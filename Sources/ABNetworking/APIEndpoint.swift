import Foundation

public protocol APIEndpoint {
    var scheme: String { get }
    var baseUrl: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension APIEndpoint {
    var scheme: String {
        return "https"
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}

public extension APIEndpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseUrl
        components.path = "/" + path
        components.queryItems = queryItems
        return components.url
    }
}

