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

typealias FirebaseListHandler  = ( [FirebaseObject] ) -> Void

protocol FirebaseObject {
    var id: String? { get }
    
    init(id: String, json: NSDictionary)
    func toDictionary() -> NSDictionary
}

struct FireBaseService <Object: FirebaseObject> {
    
    var ref =  FIRDatabase.database().reference()

    func delete(withNodeKey nodeKey: String, object: Object)  {
       ref.child(nodeKey).child(object.id!).removeValue()
    }

    func create(withNodeKey nodeKey: String, object: Object) {
        let dictionary = object.toDictionary()
        
        ref.child(nodeKey).childByAutoId().setValue(dictionary)
    }
    
    func list(withNodeKey nodeKey: String, completionHandler: @escaping FirebaseListHandler) {
        ref.child(nodeKey).observeSingleEvent(of: .value, with: { (snapshot) in
            if let objects = snapshot.value as? [String : Any] {
                let objectsList = objects.map { Object(id: $0, json: $1 as! NSDictionary) }
                
                completionHandler(objectsList)
            } else {
                completionHandler([])
            }
        })
    }
    
    func listAndObserve(atNodeKey nodeKey: String, completionHandler: @escaping (FirebaseObject?) -> Void) {
        ref.child(nodeKey).queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let object = snapshot.value as? [String : Any] {
                completionHandler(Object(id: snapshot.key, json: object as NSDictionary))
            } else {
                completionHandler(nil)
            } 
        })
    }
    
    func didRemoveObject(atNodeKey nodeKey: String, completionHandler: @escaping (FirebaseObject?) -> Void) {
        ref.child(nodeKey).observe(.childRemoved, with: { (snapshot) in
            if let object = snapshot.value as? [String : Any] {
                completionHandler(Object(id: snapshot.key, json: object as NSDictionary))
            } else {
                completionHandler(nil)
            }
        })
    }
    
    func didChangeObject(atNodeKey nodeKey: String, completionHandler: @escaping (FirebaseObject?) -> Void) {
        ref.child(nodeKey).observe(.childChanged, with: { (snapshot) in
            if let object = snapshot.value as? [String : Any] {
                completionHandler(Object(id: snapshot.key, json: object as NSDictionary))
            } else {
                completionHandler(nil)
            }
        })
    }
    
    func dismmissObservers(){
        ref.removeAllObservers()
    }
}
