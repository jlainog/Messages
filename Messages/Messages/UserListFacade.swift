//
//  UserListFacade.swift
//  Messages
//
//  Created by Luis Ramirez on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase

typealias UserResponseHandler = (_ userResponse : User) -> Void

struct UserListFacade {
    static let ref : FIRDatabaseReference! = FIRDatabase.database().reference().child("users")
    
    static func observeUsers(completion: @escaping UserResponseHandler) {
            ref.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else {
                return
            }
            completion(User(json: value as NSDictionary))
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func createUser(user: User) {
        ref.child(user.identifier).setValue(user.buildJSON())
    }
    
    static func removeObservers() {
        ref.removeAllObservers()
    }
}

