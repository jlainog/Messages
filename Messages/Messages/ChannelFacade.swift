//
//  ChannelFacade.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/10/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol ChannelServiceProtocol {
    func listChannels(completionHandler: @escaping channelHandler)
    func create(channel: Identificable)
    func delete(channel: Identificable)
}

struct ChannelFacade: ChannelServiceProtocol {
    
    let key: String
    static var service = FireBaseService<PublicChannel>()   
    
    func listChannels(completionHandler: @escaping channelHandler) {
        ChannelFacade.service.listObjects(completionHandler: completionHandler, dicKey: key)
    }
    
    func create(channel: Identificable) {
        ChannelFacade.service.createObjectWith(dicKey: key) { () -> [String : Any] in
            return ["content" : channel.content!]
        }
    }
    
    func delete(channel: Identificable) {
        ChannelFacade.service.delete(object: channel as! PublicChannel, dicKey: key)
    }
    
}
