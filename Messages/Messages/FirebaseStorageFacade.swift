//
//  FirebaseStorageService.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController

struct FirebaseStorageFacade {
    
    static let storageRef = FIRStorage.storage().reference().child("Devices_Images")

    static func save(withId id: String, userName: String, media: UIImage, channelId: String) {
 
        let mediaData = MediaImage.init(id: "perro", image: media)
        
        if let uploadData = UIImagePNGRepresentation((mediaData.imgView.image)!) {
            let uploadTask = storageRef.child("\(mediaData.id!).png").put(uploadData, metadata: nil)
            
            uploadTask.observe(.success) { snapshot in
                let message = Message(userId: id,
                                      userName: userName,
                                      mediaUrl: (snapshot.metadata!.downloadURL()!.absoluteString),
                                      mediaItem: nil)
                ChatFacade.createMessage(channelId: channelId, message: message)
            }
        }
        
    }

}
