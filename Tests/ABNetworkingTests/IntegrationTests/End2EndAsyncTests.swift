import XCTest
@testable import ABNetworking

final class End2EndAsyncTests: XCTestCase {
    private let client = JsonApiClient()
}

// MARK: - Succesful Async tests
extension End2EndAsyncTests {
    
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

// MARK: - Failing Async tests
extension End2EndAsyncTests {
    
    func testFailingRequestForWrongHostname() async throws {
        let request = ErroringHostRequest()
        do {
            let _: User = try await self.client.start(request)
        } catch {
            let abError = try XCTUnwrap(error as? ABNetworkingError)
            guard case ABNetworkingError.urlSessionError(_) = abError else {
                XCTFail()
                return
            }
        }
    }
    
    func testFailingRequestForWrongPath() async throws {
        let request = ErroringPathRequest()
        do {
            let _: User = try await self.client.start(request)
        } catch {
            let abError = try XCTUnwrap(error as? ABNetworkingError)
            guard case ABNetworkingError.urlSessionError(_) = abError else {
                XCTFail()
                return
            }
        }
    }
    
    func testFailingRequestForWrongMethod() async throws {
        let request = ErroringMethodRequest()
        do {
            let _: User = try await self.client.start(request)
        } catch {
            let abError = try XCTUnwrap(error as? ABNetworkingError)
            guard case ABNetworkingError.urlSessionError(_) = abError else {
                XCTFail()
                return
            }
        }
    }
    
    func testFailingRequestForWrongResultType() async throws {
        let request =  GetUsersRequest()
        do {
            let _: User = try await self.client.start(request)
        } catch {
            let abError = try XCTUnwrap(error as? ABNetworkingError)
            guard case ABNetworkingError.couldNotParseResult(_) = abError else {
                XCTFail()
                return
            }
        }
    }
    
    func testFailingRequestForCancellation() async throws {
        let request =  GetUsersRequest()
        do {
        
            let task = Task<[User], Error>(priority: .high, operation: {
                try await client.start(request)
            })
            
            task.cancel()
            let _ = try await task.value
   
        } catch {
            XCTAssert(error is CancellationError)
        }
    }
}
