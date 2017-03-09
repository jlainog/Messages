//
//  Message.swift
//  Messages
//
//  Created by Jaime Laino on 3/9/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol MessageInfo : Parseable {
    var userId : Int { get }
    var message: String { get }
    var messageType : MessageType { get }
    var timestamp : String { get }
}

class Message : MessageInfo {
    var userId: Int
    var message: String
    var messageType: MessageType
    var timestamp: String
    
    required init(json: [String: Any]) {
        self.userId = json["userId"] as? Int ?? 0
        self.message = json["message"] as? String ?? ""
        self.messageType = json["messageType"] as? MessageType ?? .text
        self.timestamp = json["timestamp"] as? String ?? ""
    }
}
