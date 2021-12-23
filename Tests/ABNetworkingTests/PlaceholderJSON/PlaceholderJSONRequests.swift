import ABNetworking
import Foundation

struct UserEndpoint: APIEndpoint {

    private static let path = "users"

    let userIdentifier: Int?
    var baseUrl: String = "jsonplaceholder.typicode.com"
    var isPathWrong: Bool = false
    
    var path: String {
        var path = UserEndpoint.path + (isPathWrong ? "###" : "")
        if let userIdentifier = userIdentifier {
            path.append("/\(userIdentifier)")
        }
        return path
    }

    init(userIdentifier: Int? = nil) {
        self.userIdentifier = userIdentifier
    }
    
    static var failingHost: UserEndpoint {
        var userEndpoint = UserEndpoint()
        userEndpoint.baseUrl = "wrooong"
        return userEndpoint
    }
    
    static var failingPath: UserEndpoint {
        var userEndpoint = UserEndpoint()
        userEndpoint.isPathWrong = true
        return userEndpoint
    }
}


// MARK: - Successful Requests
struct GetUsersRequest: APIRequest {
    let endpoint: APIEndpoint = UserEndpoint()
    let method = HTTPMethod.get
}

struct GetUserRequest: APIRequest {
    let userIdentifier: Int
    var endpoint: APIEndpoint {
        return UserEndpoint(userIdentifier: userIdentifier)
    }
    let method = HTTPMethod.get
}

struct DeleteUserRequest: APIRequest {
    let userIdentifier: Int
    var endpoint: APIEndpoint {
        return UserEndpoint(userIdentifier: userIdentifier)
    }
    let method = HTTPMethod.delete
}

struct CreateUserRequest: APIRequest {
    typealias Resource = User

    let newUser: User
    let endpoint: APIEndpoint = UserEndpoint()
    let method = HTTPMethod.post
    var body: Data? {
        return try? newUser.encodeAsJson()
    }
}

struct UpdateUserRequest: APIRequest {
    typealias Resource = User

    let updatedUser: User
    var endpoint: APIEndpoint {
        return UserEndpoint(userIdentifier: updatedUser.identifier)
    }
    let method = HTTPMethod.put
    var body: Data? {
        return try? updatedUser.encodeAsJson()
    }
}

// MARK: - Erroring Requests
struct ErroringHostRequest: APIRequest {
    let endpoint: APIEndpoint = UserEndpoint.failingHost
    let method = HTTPMethod.get
}

struct ErroringPathRequest: APIRequest {
    let endpoint: APIEndpoint = UserEndpoint.failingPath
    let method = HTTPMethod.get
}

struct ErroringMethodRequest: APIRequest {
    let endpoint: APIEndpoint = UserEndpoint()
    let method = HTTPMethod.patch
}

// MARK: - Helpers
struct CodableVoid: Codable {
    var void: Void { return () }
}

extension Encodable {
    func encodeAsJson() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
