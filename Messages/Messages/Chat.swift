//
//  Chat.swift
//  Messages
//
//  Created by Luis Ramirez on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.


import Foundation

enum MessageType : String {
    case text
}

protocol ChatInfo : Parseable {
    var messages : [Message] { get }
}

struct Chat : ChatInfo {
    var messages: [Message]
    
    init(json: NSDictionary) {
        guard let chatMessages = json["messages"] as? NSDictionary else {
            self.messages = [Message]()
            return
        }
        self.messages = [Message(json: chatMessages)]
    }
}
