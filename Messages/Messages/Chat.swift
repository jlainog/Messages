//
//  Chat.swift
//  Messages
//
//  Created by Luis Ramirez on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.


import Foundation

enum MessageType {
    case text
}

protocol ChatInfo : Parseable {
    var channelId : Int { get }
    var userId : Int { get }
    var messages : [Message] { get }
    var messageType : MessageType { get }
    var time : NSNumber { get }
}

struct Chat : ChatInfo {
    var channelId: Int
    var userId: Int
    var messages: [Message]
    var messageType: MessageType
    var time: NSNumber
    
    init(json: [String : Any]) {
        self.channelId = json["chatId"] as? Int ?? 0
        self.userId = json["userId"] as? Int ?? 0
        self.messages = json["message"] as? [Message] ?? [Message]()
        self.messageType = json["messageType"] as? MessageType ?? .text
        self.time = (json["time"] as? NSNumber)!
    }
}


