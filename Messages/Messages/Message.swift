//
//  Message.swift
//  Messages
//
//  Created by Luis Ramirez on 3/9/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import JSQMessagesViewController

enum MessageType : String {
    case text
    case location
    case media
}

protocol MessageInfo : Parseable, JSQMessageData {
    var userId: String { get }
    var userName: String { get }
    var message: String { get }
    var messageType : MessageType { get }
    var timestamp: Double { get }
    var latitude: Double { get }
    var longitude: Double { get }
}

class Message : NSObject, MessageInfo {
    var userId: String
    var userName: String
    var message: String
    var messageType: MessageType
    var timestamp: Double
    var latitude: Double
    var longitude: Double
    let locationMediaItem = JSQLocationMediaItem(maskAsOutgoing: true)
    
    required init(json: NSDictionary) {
        self.userId = json["userId"] as? String ?? ""
        self.userName = json["userName"] as? String ?? ""
        self.message = json["message"] as? String ?? ""
        self.timestamp = json["timestamp"] as? Double ?? 0
        self.latitude = json["latitude"] as? Double ?? 0
        self.longitude = json["longitude"] as? Double ?? 0
        self.messageType = MessageType.text
        
        guard let messageTypeString = json["messageType"] as? String else {
            return
        }
        
        self.messageType = MessageType(rawValue: messageTypeString)!
    }
    
    convenience init(userId: String, userName: String, message: String, messageType: MessageType = .text, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        let json = ["userId": userId, "userName": userName, "message": message, "messageType": messageType, "timestamp": timestamp] as NSDictionary
        self.init(json: json)
    }
    
    convenience init(userId: String, userName: String, location: CLLocation) {
        let json = ["userId": userId, "userName": userName] as NSDictionary
        self.init(json: json)
        
        self.timestamp = Date().timeIntervalSince1970
        self.messageType = MessageType.location
//        self.latitude = location.coordinate.latitude
//        self.longitude = location.coordinate.longitude
        self.latitude = 10
        self.longitude = 10
    }
    
    func buildJSON() -> NSDictionary {
        var json = Dictionary<String, Any>()
        
        json["userId"] = userId
        json["userName"] = userName
        json["message"] = message
        json["messageType"] = messageType.rawValue
        json["timestamp"] = timestamp
        json["latitude"] = latitude
        json["longitude"] = longitude
        return json as NSDictionary
    }
}

//MARK: JSQMessageData

extension Message {
    func senderId() -> String! {
        return self.userId
    }
    
    func senderDisplayName() -> String! {
        return self.userName
    }
    
    func text() -> String! {
        return self.message
    }
    
    func isMediaMessage() -> Bool {
        return self.messageType != .text
    }
    
    func media() -> JSQMessageMediaData! {
        if self.messageType == .location {
            print("location \(locationMediaItem?.location)")
            return locationMediaItem
        }
        
        return nil
    }
    
    func date() -> Date! {
        return Date(timeIntervalSince1970: self.timestamp)
    }
    
    func messageHash() -> UInt {
        return UInt(self.hashValue)
    }
}
