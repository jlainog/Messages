//
//  Cahnnel.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

struct Chat:Parseable {
    var text:String
    var id:Int
    
    init(json: [String : Any]) {
        text = "uno"
        id = 1
    }
    
    init(id:Int) {
        text = "uno"
        self.id = 1
    }
}

protocol ChannelProtocol:Parseable {
    var id:Int?{get}
    var name:String?{set get}
    var messages:[Chat]?{get}
}

class PublicChannel: ChannelProtocol {
    internal let id: Int?
    internal var name: String?
    internal var messages: [Chat]?
    
    required init(json: [String : Any]) {
        
        guard let channelDictionary = json["channels"] as? [String:Any] else{
            id = nil
            name = nil
            return
        }
        
        self.id = channelDictionary["id"] as? Int
        self.name = channelDictionary["name"] as? String
        
        guard let messagesDictionary = json["messages"] as? [String:Any], let chatDictionary = messagesDictionary["\(self.id)"] as? [String:Any]   else{
            messages = nil
            return
        }
        self.messages = chatDictionary.enumerated().map(){ Chat(json:($1.value as! [String:Any]))}
    }
    
}
