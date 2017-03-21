//
//  User.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

class User: UserInfo {
    var identifier : String?
    var name : String?
    var email : String?
    var password : String?
    
    init(identifier:String, name:String, email: String? = nil, password: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.email = email
        self.password = password
    }
}
