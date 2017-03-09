//
//  User.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

class User {
    var identifier: Int?
    var name: String?
    var email: String?
    
    init(identifier:Int, name:String, email: String){
        self.identifier = identifier
        self.name = name
        self.email = nil
    }
}
