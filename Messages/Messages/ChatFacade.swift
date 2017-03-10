//
//  ChatFacade.swift
//  Messages
//
//  Created by Luis Ramirez on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase

typealias ChatResponseHandler = (_ chatResponse : [Message]) -> Void

struct ChatFacade {
    static let ref : FIRDatabaseReference! = FIRDatabase.database().reference().child("messages")

    static func retrieveChat(channelId: String, completion: @escaping ChatResponseHandler) {
        var messages = [Message]()
        //Investigate observe.
        ref.child(channelId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else {
                return
            }
            let orderedDic = value.sorted(by: { $0.0 < $1.0 })
            for messageDic in orderedDic {
                messages.append(Message(json: messageDic.value as! NSDictionary))
            }
            completion(messages)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func createMessage(channelId: String, message: Message) {
        ref.child(channelId).childByAutoId().setValue(message.buildJSON())
    }
}
