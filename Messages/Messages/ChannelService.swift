//
//  ChannelService.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase

protocol ChannelServiceProtocol {
    
    func listChannels(completionHandler: @escaping (_ data:[ChannelProtocol]) -> Void)
    func createChannel(channel:ChannelProtocol)-> URLResponse
    func deleteChannel(channel:ChannelProtocol) -> URLResponse
    
}
//
//struct ChannelService:ChannelServiceProtocol {
//    internal func deleteChannel(channel: ChannelProtocol) -> URLResponse {
//        
//    }
//
//    internal func createChannel(channel: ChannelProtocol) -> URLResponse {
//        
//    }
//
//   
//    func listChannels(completionHandler: @escaping ([ChannelProtocol]) -> Void) {
//        
//    }
//}
