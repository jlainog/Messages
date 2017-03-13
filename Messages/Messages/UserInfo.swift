//
//  UserInfo.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/8/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol UserInfo {
    var identifier : Int? { get }
    var name : String? { get set }
    var email : String? { get }
}
