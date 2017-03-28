//
//  User.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding, UserInfo {
    var identifier: String
    var name: String
    var email: String?
    var password: String?
    
    init(identifier:String, name:String, email: String? = nil, password: String?) {
        self.identifier = identifier
        self.name = name
        self.email = email
        self.password = password
    }
    
    convenience init(json: NSDictionary) {
        let identifier = json["identifier"] as? String ?? ""
        let name = json["name"] as? String ?? ""
        let email = json["email"] as? String ?? ""
        let password = json["passowrd"] as? String ?? ""
        self.init(identifier: identifier, name: name, email: email, password: password)
    }
    
    func buildJSON() -> NSDictionary {
        var json = Dictionary<String, Any>()
        
        json["identifier"] = identifier
        json["name"] = name
        json["email"] = email
        json["password"] = password
        return json as NSDictionary
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(forKey: "identifier") as? String,
        let name = aDecoder.decodeObject(forKey: "name") as? String,
        let email = aDecoder.decodeObject(forKey: "email") as? String,
        let password = aDecoder.decodeObject(forKey: "password") as? String
            else { return nil }
        self.init(identifier: identifier, name: name, email: email, password: password)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.identifier, forKey: "identifier")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.password, forKey: "password")
    }
}
