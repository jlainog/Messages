//
//  ChatFacade.swift
//  Messages
//
//  Created by Luis Ramirez on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase

typealias ChatResponseHandler = (_ chatResponse : Message) -> Void

struct ChatFacade {
    static let ref : FIRDatabaseReference! = FIRDatabase.database().reference().child("messages")
    
    static func observeMessages(byListingLast last: UInt, channelId: String, completion: @escaping ChatResponseHandler) {
        let refChat = ref.child(channelId).queryLimited(toLast: last)
        refChat.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else {
                return
            }
            completion(Message(json: value as NSDictionary))
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func createMessage(channelId: String, message: Message) {
        ref.child(channelId).childByAutoId().setValue(message.buildJSON())
    }
    
    static func removeMessages(channelId: String) {
        ref.child(channelId).removeValue()
    }
    
    static func removeAllObservers() {
        ref.removeAllObservers()
    }
    
}
    
