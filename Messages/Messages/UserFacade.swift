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
    
    //Email + Passowrd Log In
    func emailPasswordLogIn(email: String, userName: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void ) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if(error != nil)  {
                completion(nil, error!)
                
                return
            }
            
            let userObj : User = User(identifier: user!.uid, name: userName, email: email)
            completion(userObj, nil)

        })
    }
    
    //Anonymous Log In
    func anonymousLogIn(userName: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error)  in
            if (error != nil) {
                completion(nil, error!)
    
                return
            }
            
            let userObj : User = User(identifier: user!.uid, name: userName)
            completion(userObj, nil)
        })
    }
    
    //User sign in
    func userSignIn(email: String, password: String, userName: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void ){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if(error != nil)  {
                completion(nil, error!)
                
                return
            }
            
            let userObj : User = User(identifier: user!.uid, name: userName, email: email)
            completion(userObj, nil)
        })
    }
    
    func userLogOut(){
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
        }
    }
}
