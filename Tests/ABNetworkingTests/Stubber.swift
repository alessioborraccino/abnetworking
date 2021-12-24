//
//  File.swift
//  
//
//  Created by Alessio Borraccino on 24.12.21.
//

import Foundation
import Hippolyte

final class Stubber {
    
    static let `default` = Stubber()
    
    func start() {
        Hippolyte.shared.start()
    }
    
    func stop() {
        Hippolyte.shared.stop()
    }
}

extension Stubber {
    func stubGetUser(identifier: Int) throws {
        let user = User(identifier: identifier, name: "nameOne", email: "email@email.one", userName: "username", phone: nil, website: nil, address: nil, company: nil)
        
        let userData = try JSONEncoder().encode(user)
        
        let responseGetUser = StubResponse.Builder()
            .stubResponse(withStatusCode: 200)
            .addBody(userData)
            .build()
        let requestGetUser = StubRequest.Builder()
            .stubRequest(withMethod: .GET, url: UserEndpoint(userIdentifier: identifier).url!)
          .addResponse(responseGetUser)
          .build()
        
        Hippolyte.shared.add(stubbedRequest: requestGetUser)
    }
    
    func stubGetUsers() throws {
        let userOne = User(identifier: 1, name: "nameOne", email: "email@email.one", userName: "username1", phone: nil, website: nil, address: nil, company: nil)
        let userTwo = User(identifier: 2, name: "nameTwo", email: "email@email.two", userName: "username2", phone: nil, website: nil, address: nil, company: nil)
        let users = [userOne, userTwo]
        let usersData = try JSONEncoder().encode(users)
    
        let responseGetUsers = StubResponse.Builder()
            .stubResponse(withStatusCode: 200)
            .addBody(usersData)
            .build()
        
          let requestGetUsers = StubRequest.Builder()
            .stubRequest(withMethod: .GET, url: UserEndpoint().url!)
            .addResponse(responseGetUsers)
            .build()
        Hippolyte.shared.add(stubbedRequest: requestGetUsers)
    }
}
