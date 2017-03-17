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
    var userId: String { get }
    var userName: String { get }
    var message: String? { get }
    var messageType : MessageType { get }
    var mediaItem: UIImage? {get}
    var timestamp: Double { get }
}

class Message : NSObject, MessageInfo {
    var userId: String
    var userName: String
    var mediaItem: UIImage?
    var message: String?
    var messageType: MessageType
    var timestamp: Double
    
    required init(json: NSDictionary) {
        self.userId = json["userId"] as? String ?? ""
        self.userName = json["userName"] as? String ?? ""
        self.mediaItem = json["mediaItem"] as? UIImage ?? DataCoder.Image(fromBase64: json["mediaItem"] as? String)
        self.message = json["message"] as? String ?? ""
        self.messageType =  MessageType(rawValue: json["messageType"] as! String) ?? MessageType.text
        self.timestamp = json["timestamp"] as? Double ?? 0
    }
    
    convenience init(userId: String, userName: String, message: String, messageType: MessageType = .text, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        let json = ["userId": userId, "userName": userName, "message": message, "messageType": messageType.rawValue, "timestamp": timestamp] as NSDictionary
        self.init(json: json)
    }
    
    convenience init(userId: String, userName: String, mediaItem: UIImage, messageType: MessageType = .media, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        let json = ["userId": userId, "userName": userName, "mediaItem": mediaItem, "messageType": messageType.rawValue, "timestamp": timestamp] as NSDictionary
        self.init(json: json)
    }
    
    
    func buildJSON() -> NSDictionary {
        var json = Dictionary<String, Any>()
        
        json["userId"] = userId
        json["userName"] = userName
        json["mediaItem"] = DataCoder.base64(fromImage: mediaItem)
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
    
    func media() -> JSQMessageMediaData! {
        return JSQPhotoMediaItem(image: self.mediaItem)
    }
    func text() -> String! {
        return self.message
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

