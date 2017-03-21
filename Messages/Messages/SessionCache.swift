//
//  SessionCache.swift
//  Messages
//
//  Created by Luis Ramirez on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

class SessionCache {
    var user = User(identifier: "Default", name: "Default")
    
    static let sharedInstance = SessionCache()
    
    private init (){ }
    
}
