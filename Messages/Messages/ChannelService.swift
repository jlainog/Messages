//
//  ChannelService.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase

typealias channelHandler  = (_ data:[ChannelProtocol]) -> Void

protocol ChannelServiceProtocol {

    func listChannels(completionHandler: @escaping channelHandler)
    func createChannel(channel:ChannelProtocol)
    func deleteChannel(channel:ChannelProtocol)
    
}

class ChannelService:ChannelServiceProtocol {
    
    var ref: FIRDatabaseReference!

    internal func deleteChannel(channel: ChannelProtocol)  {
        ref = FIRDatabase.database().reference()
    }

    internal func createChannel(channel: ChannelProtocol) {
        ref = FIRDatabase.database().reference().child("channels")
        ref.childByAutoId().setValue(["name":channel.name!])
    }

   
    func listChannels(completionHandler: @escaping channelHandler) {
        ref = FIRDatabase.database().reference()
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            if let response = snapshot.value as? [String : Any],let channels = response["channels"] as? [String:Any]{
                let sortedChannels = channels.sorted(){ $0.0 < $1.0 }
                let channelsArray = sortedChannels.map(){PublicChannel(json:$1 as! NSDictionary)}
                completionHandler(channelsArray)
            }
        })
    }
}
