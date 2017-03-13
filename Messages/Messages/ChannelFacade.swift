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
    func listChannels(completionHandler: @escaping ChannelListHandler)
    func create(channel: PublicChannel)
    func delete(channel: PublicChannel)
}

struct ChannelFacade: ChannelServiceProtocol {
    
    let nodeKey: String = "channels"
    let service = FireBaseService<PublicChannel>()
    
    func listChannels(completionHandler: @escaping ChannelListHandler) {
        service.list(withNodeKey: nodeKey) {
            list in
            completionHandler( list.map { $0 as! PublicChannel } )
        }
    }
    
    func didAddChannel(completionHandler: @escaping (PublicChannel) -> Void) {
        service.didAddObject(atNodeKey: nodeKey) { (firebaseObject) in
            guard let newObject = firebaseObject else { return }
            
            completionHandler(newObject as! PublicChannel)
        }
    }
    
    func create(channel: PublicChannel) {
        service.create(withNodeKey: nodeKey, object: channel)
    }
    
    func delete(channel: PublicChannel) {
        service.delete(withNodeKey: nodeKey, object: channel)
    }
    
}
