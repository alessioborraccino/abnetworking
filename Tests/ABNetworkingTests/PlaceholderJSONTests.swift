import XCTest
@testable import ABNetworking

final class PlaceholderJSONTests: XCTestCase {
    private let client = JsonApiClient()
}

// MARK: - Succesful Async tests
extension PlaceholderJSONTests {
    
    func testGetUsers() async throws {
        let request = GetUsersRequest()
        let users: [User] = try await client.start(request)
        XCTAssertEqual(users.count, 10)
    }

    func testGetUser() async throws {
        let identifier = 1
        let request = GetUserRequest(userIdentifier: identifier)
        let user: User = try await client.start(request)
        XCTAssertEqual(user.identifier, identifier)
    }
}

