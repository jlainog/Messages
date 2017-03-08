//
//  UserInfo.swift
//  Messages
//
//  Created by Jose Daniel Lopez Franco on 3/8/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

protocol UserInfo {
    var userId:Int?{get}
    var userName:String?{get set}
    var userEmail:String?{get}
}
