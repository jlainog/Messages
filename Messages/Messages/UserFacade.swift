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
    
    func anonymousLogIn (userName: String){
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error)  in
            if (error != nil) {
                print("Anonymous auth failed")
                return
            }
            print("Congrat! you are in")
        }
        )
    }
}
 
