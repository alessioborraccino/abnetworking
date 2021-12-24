//
//  File.swift
//  
//
//  Created by Alessio Borraccino on 23.12.21.
//

import Foundation

import XCTest
import Hippolyte
@testable import ABNetworking

final class StubbedNetworkTests: XCTestCase {
    private let client = JsonApiClient()
    
    override func setUpWithError() throws {
        try Stubber.default.stubGetUser(identifier: 1)
        try Stubber.default.stubGetUsers()
        Stubber.default.start()
    }
    
    override func tearDownWithError() throws {
        Stubber.default.stop()
    }
}

// MARK: - Succesful Async tests
extension StubbedNetworkTests {
    
    func testGetUsers() async throws {
        let request = GetUsersRequest()
        let users: [User] = try await client.start(request)
        XCTAssertEqual(users.count, 2)
    }
    
    func testGetUser() async throws {
        let identifier = 1
        let request = GetUserRequest(userIdentifier: identifier)
        let user: User = try await client.start(request)
        XCTAssertEqual(user.identifier, identifier)
    }
}
