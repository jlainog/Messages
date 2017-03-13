//
//  Cahnnel.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

struct PublicChannel: FirebaseObject {
    
    var id: String?
    var name: String
    
    init(id: String, json: NSDictionary) {
        self.name = json[ "channelName" ] as? String ?? "Unknow"
        self.id = id
    }
    
    init(name: String) {
        self.name = name
    }
  
    func toDictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary["channelName"] = name
        return dictionary
    }
}
