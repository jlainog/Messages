//
//  ChannelFacade.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/10/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

typealias ChannelListHandler  = ([PublicChannel]) -> Void

protocol ChannelServiceProtocol {
    static func listChannels(completionHandler: @escaping ChannelListHandler)
    static func create(channel: PublicChannel)
    static func delete(channel: PublicChannel)
}

struct ChannelFacade: ChannelServiceProtocol {
    
    static let nodeKey: String = "channels"
    static let service = FireBaseService<PublicChannel>()
    
     static func listChannels(completionHandler: @escaping ChannelListHandler) {
        service.list(withNodeKey: nodeKey) {
            list in
            completionHandler( list.map { $0 as! PublicChannel } )
        }
    }
    
     static func didAddChannel(completionHandler: @escaping (PublicChannel) -> Void) {
        service.didAddObject(atNodeKey: nodeKey) { (firebaseObject) in
            guard let newObject = firebaseObject else { return }
            
            completionHandler(newObject as! PublicChannel)
        }
    }
    
    static func didRemoveChannel(completionHandler: @escaping (PublicChannel) -> Void) {
        service.didRemoveObject(atNodeKey: nodeKey) { (firebaseObject) in
            guard let newObject = firebaseObject else { return }
            
            completionHandler(newObject as! PublicChannel)
        }
    }
    
    static func create(channel: PublicChannel) {
        service.create(withNodeKey: nodeKey, object: channel)
    }
    
    static func delete(channel: PublicChannel) {
        service.delete(withNodeKey: nodeKey, object: channel)
    }
    
}
