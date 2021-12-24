//
//
//  
//
//  Created by Alessio Borraccino on 24.12.21.
//

import Foundation
import XCTest
import ABNetworking

final class ABNetworkingErrorTests: XCTestCase {
    
    func testURLErrorDescription() {
        let error = ABNetworkingError.urlSessionError(NSError(domain: "test", code: 1, userInfo: nil))
        XCTAssertNotNil(error.errorDescription)
    }
    
    func testParseErrorDescription() {
        let error = ABNetworkingError.couldNotParseResult(NSError(domain: "test", code: 1, userInfo: nil))
        XCTAssertNotNil(error.errorDescription)
    }
    
    func testNoResourceErrorDescription() {
        let error = ABNetworkingError.noResourceFound
        XCTAssertNotNil(error.errorDescription)
    }
    
    func testNoHttpResponseErrorDescription() {
        let error = ABNetworkingError.receivedNonHttpResponse
        XCTAssertNotNil(error.errorDescription)
    }
}
