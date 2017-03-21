//
//  User.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

class User: UserInfo {
    var identifier: String?
    var name: String?
    var email: String?
    
    init(identifier:String, name:String, email: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.email = email
    }
    
    convenience init(json: NSDictionary) {
        let identifier = json["identifier"] as? String ?? ""
        let name = json["name"] as? String ?? ""
        let email = json["email"] as? String ?? ""
        self.init(identifier: identifier, name: name, email: email)
    }
    
    func buildJSON() -> NSDictionary {
        var json = Dictionary<String, Any>()
        
        json["identifier"] = identifier
        json["name"] = name
        json["email"] = email
        return json as NSDictionary
    }
}
