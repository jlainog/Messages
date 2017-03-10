//
//  ChannelService.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase

typealias channelHandler  = (_ data:[Identificable]) -> Void

struct FireBaseService {
    
    var ref =  FIRDatabase.database().reference()

    internal func delete(object: Identificable,dicKey: String)  {
    }

    internal func createObjectWith(dicKey: String, objectAsDic: () -> [String: Any]) {
        ref.child(dicKey).childByAutoId().setValue(objectAsDic())
    }

    func listObjects(completionHandler: @escaping channelHandler,dicKey: String) {
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            if let response = snapshot.value as? [String : Any],let channels = response[dicKey] as? [String:Any]{
                let sortedChannels = channels.sorted(){ $0.0 < $1.0 }
                let channelsArray = sortedChannels.map(){PublicChannel(id: channels.keys.first!, json: $1 as! NSDictionary)}
                completionHandler(channelsArray)
            }
        })
    }
}
