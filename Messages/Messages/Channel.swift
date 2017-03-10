//
//  Cahnnel.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol ChannelProtocol: Parseable {
    var id:String? { set get }
    var name:String? { set get }
}

struct PublicChannel: ChannelProtocol {
    
    internal var id:String?
    internal var name: String?
    
    init(json: NSDictionary) {
        self.name = json["name"] as? String
    }
    
    init(id: String, json: NSDictionary) {
        self.init(json:json)
        self.id = id
    }
    
    init(name:String) {
        self.name = name
    }
    
}
