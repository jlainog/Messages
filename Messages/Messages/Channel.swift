//
//  Cahnnel.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol Identificable: Parseable {
    var id: String? { set get }
    var content: String? { set get }
    
    init(id: String, json: NSDictionary)
}

struct PublicChannel: Identificable {
    
    internal var id: String?
    internal var content: String?
    
    init(json: NSDictionary) {
        self.content = json[ "content" ] as? String
    }
    
    init(id: String, json: NSDictionary) {
        self.init(json:json)
        self.id = id
    }
    
    init(content: String) {
        self.content = content
    }
    
}
