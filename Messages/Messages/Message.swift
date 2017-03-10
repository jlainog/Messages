//
//  Message.swift
//  Messages
//
//  Created by Jaime Laino on 3/9/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

enum MessageType {
    case text
}

extension MessageType {
    var type: String {
        switch self {
        case .text: return "text"
        }
    }
}

protocol MessageInfo : Parseable {
    var userId : String { get }
    var userName : String { get }
    var message: String { get }
    var messageType : MessageType { get }
    var timestamp : Double { get }
}

class Message : MessageInfo {
    var userId: String
    var userName: String
    var message: String
    var messageType: MessageType
    var timestamp: Double
    
    required init(json: NSDictionary) {
        self.userId = json["userId"] as? String ?? ""
        self.userName = json["userName"] as? String ?? ""
        self.message = json["message"] as? String ?? ""
        self.messageType = json["messageType"] as? MessageType ?? MessageType.text
        self.timestamp = json["timestamp"] as? Double ?? 0
    }
    
    func buildJSON() -> NSDictionary {
        var json = Dictionary<String, Any>()
        
        json["userId"] = userId
        json["userName"] = userName
        json["message"] = message
        json["messageType"] = messageType.type
        json["timestamp"] = timestamp
        return json as NSDictionary
    }
}
