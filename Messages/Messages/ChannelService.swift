//
//  ChannelService.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/7/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

typealias channelHandler  = (_ data:[Identificable]) -> Void

struct FireBaseService <Object: Identificable>{
    
    var ref =  FIRDatabase.database().reference()

    internal func delete(object: Object,dicKey: String)  {
       ref.child(dicKey).child(object.id!).removeValue()
    }

    internal func createObjectWith(dicKey: String, objectAsDic: () -> [String: Any]) {
        ref.child(dicKey).childByAutoId().setValue(objectAsDic())
    }

    internal func listObjects (completionHandler: @escaping channelHandler,dicKey: String) {
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            if let response = snapshot.value as? [String : Any],let objects = response[dicKey] as? [String:Any]{
                let sortedObjects = objects.sorted(){ $0.0 < $1.0 }
                let objectsArray = sortedObjects.map(){ Object(id: objects.keys.first!, json: $1 as! NSDictionary)}
                completionHandler(objectsArray)
            } else {
                completionHandler([])
            }
        })
    }
}
