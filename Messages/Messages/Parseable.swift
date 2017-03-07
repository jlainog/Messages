//
//  Parseable.swift
//  Messages
//
//  Created by Luis Ramirez on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol Parseable {
    init(json: [String: Any])
}
