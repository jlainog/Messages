//
//  Observermanager.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/15/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol Observer {
    var id: Int { get }
}

protocol Observable {
    func addObserver(observer: Observer)
    func removeObservers()
}

struct ChatObserver: Observer {
    let id: Int
}
