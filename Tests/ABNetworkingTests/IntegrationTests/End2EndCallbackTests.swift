import XCTest
@testable import ABNetworking

final class End2EndCallbackTests: XCTestCase {
    private let client = JsonApiClient()
    private let timeout: TimeInterval = 1
}

// MARK: - Succesful Callback tests
extension End2EndCallbackTests {
    
    func testGetUsers() throws {
        let expectation = expectation(description: "Request works")
        let request = GetUsersRequest()
        client.start(request, resource: [User].self) { result in
            XCTAssertEqual(try? result.get().count, 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testGetUser() async throws {
        let expectation = expectation(description: "Request works")
        let identifier = 1
        let request = GetUserRequest(userIdentifier: identifier)
        client.start(request, resource: User.self) { result in
            XCTAssertEqual(try? result.get().identifier, identifier)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - Failing Callback tests
extension End2EndCallbackTests {
    
    func testFailingRequestForWrongHostname() async throws {
        let expectation = expectation(description: "Request fails")
        let request = ErroringHostRequest()
        client.start(request, resource: User.self) { result in
            do {
                try _ = result.get()
            }
            catch {
                let abError = try! XCTUnwrap(error as? ABNetworkingError)
                guard case ABNetworkingError.urlSessionError(_) = abError else {
                    XCTFail()
                    return
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testFailingRequestForWrongPath() async throws {
        let expectation = expectation(description: "Request fails")
        let request = ErroringPathRequest()
        client.start(request, resource: User.self) { result in
            do {
                try _ = result.get()
            }
            catch {
                let abError = try! XCTUnwrap(error as? ABNetworkingError)
                guard case ABNetworkingError.noResourceFound = abError else {
                    XCTFail()
                    return
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testFailingRequestForWrongMethod() async throws {
        let expectation = expectation(description: "Request fails")
        let request = ErroringMethodRequest()
        client.start(request, resource: User.self) { result in
            do {
                try _ = result.get()
            }
            catch {
                let abError = try! XCTUnwrap(error as? ABNetworkingError)
                guard case ABNetworkingError.noResourceFound = abError else {
                    XCTFail()
                    return
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testFailingRequestForWrongResultType() async throws {
        let expectation = expectation(description: "Request fails")
        let request =  GetUsersRequest()
        client.start(request, resource: User.self) { result in
            do {
                try _ = result.get()
            }
            catch {
                let abError = try! XCTUnwrap(error as? ABNetworkingError)
                guard case ABNetworkingError.couldNotParseResult(_) = abError else {
                    XCTFail()
                    return
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
}
