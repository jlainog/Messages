//
//  UserFacade.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/10/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase
import UIKit



struct UserFacade {
    var firebase: FIRDatabaseReference?
    
    func anonymousLogIn(userName: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error)  in
            if (error != nil) {
                completion(nil, error!)
                print("Anonymous auth failed")
                return
            }
            let userObj : User = User(identifier: user!.uid, name: userName)
            completion(userObj, nil)
            
            print("Congrats! you are in")
        })
    }
}
 
