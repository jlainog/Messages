//
//  ChannelFacade.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/10/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

typealias ChannelListHandler  = ( [Channel] ) -> Void

protocol ChannelServiceProtocol {
    static func didRemoveChannel(completionHandler: @escaping (Channel) -> Void)
    static func listAndObserveChannels(completionHandler: @escaping (Channel) -> Void)
    static func dismmissChannelObservers()
    static func create(channel: Channel)
    static func delete(channel: Channel)
}

struct ChannelFacade: ChannelServiceProtocol {
    static let nodeKey: String = "channels"
    static let service = FireBaseService<Channel>()

    static func listAndObserveChannels(completionHandler: @escaping (Channel) -> Void) {
        service.listAndObserve(atNodeKey: nodeKey) { (firebaseObject) in
            guard let newObject = firebaseObject else { return }
            
            completionHandler(newObject as! Channel)
        }
    }
    
    static func didRemoveChannel(completionHandler: @escaping (Channel) -> Void) {
        service.didRemoveObject(atNodeKey: nodeKey) { (firebaseObject) in
            guard let newObject = firebaseObject else { return }
            
            completionHandler(newObject as! Channel)
        }
    }
    
    static func create(channel: Channel) {
        service.create(withNodeKey: nodeKey, object: channel)
    }
    
    static func delete(channel: Channel) {
        service.delete(withNodeKey: nodeKey, object: channel)
    }
    
    internal static func dismmissChannelObservers() {
        service.dismmissObservers()
    }
    
}
