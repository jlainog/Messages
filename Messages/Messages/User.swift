//
//  User.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

class User {
    var userId: Int?
    var userName: String?
    var userEmail: String?
    
    init(userId:Int, userName:String, userEmail: String){
        self.userId = userId
        self.userName = userName
        self.userEmail = nil
    }
    
    
}

