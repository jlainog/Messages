    //
//  Message.swift
//  Messages
//
//  Created by Luis Ramirez on 3/9/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import JSQMessagesViewController

enum MessageType: String {
    case text
    case media
}

protocol MessageInfo : Parseable, JSQMessageData {
    var id: String? { get }
    var userId: String { get }
    var userName: String { get }
    var message: String? { get }
    var messageType : MessageType { get }
    var mediaUrl: String? {get}
    var timestamp: Double { get }
    var mediaItem: JSQPhotoMediaItem?  { get }
}

class Message : NSObject, MessageInfo {
    
    var id: String?
    var userId: String
    var userName: String
    var mediaUrl: String?
    var message: String?
    var messageType: MessageType
    var timestamp: Double
    var mediaItem: JSQPhotoMediaItem?
    
    required init(json: NSDictionary) {
        
        let messageTypeRawValue: String = json["messageType"] as? String ?? MessageType.text.rawValue
        
        self.userId = json["userId"] as? String ?? ""
        self.userName = json["userName"] as? String ?? ""
        self.mediaUrl = json["mediaUrl"] as? String ?? ""
        self.message = json["message"] as? String ?? ""
        self.messageType =  MessageType(rawValue: messageTypeRawValue)!
        self.timestamp = json["timestamp"] as? Double ?? 0
        self.mediaItem = json["mediaItem"] as? JSQPhotoMediaItem
        
    }
    
    convenience init(userId: String, userName: String, message: String, messageType: MessageType = .text, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        let json = ["userId": userId, "userName": userName, "message": message, "messageType": messageType.rawValue, "timestamp": timestamp] as NSDictionary
        self.init(json: json)
    }
    
    convenience init(userId: String, userName: String, mediaUrl: String, messageType: MessageType = .media, timestamp: TimeInterval = Date().timeIntervalSince1970, mediaItem: JSQPhotoMediaItem?) {
        let json = ["userId": userId, "userName": userName, "mediaUrl": mediaUrl, "messageType": messageType.rawValue, "timestamp": timestamp, "mediaItem": mediaItem] as NSDictionary
        
        self.init(json: json)
    }
    
    convenience init(id:String, json: NSDictionary) {
        self.init(json: json)
        self.id = id
    }
    
    func buildJSON() -> NSDictionary {
        var json = Dictionary<String, Any>()

        json["userId"] = userId
        json["userName"] = userName
        json["mediaUrl"] = mediaUrl
        json["message"] = message
        json["messageType"] = messageType.rawValue
        json["timestamp"] = timestamp
    
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
    
    func media() -> JSQMessageMediaData! {
       return self.mediaItem
    }
    
    func isMediaMessage() -> Bool {
        return self.messageType != .text
    }
    
    func date() -> Date! {
        return Date(timeIntervalSince1970: self.timestamp)
    }
    
    func messageHash() -> UInt {
        return UInt(self.hashValue)
    }
    
}
