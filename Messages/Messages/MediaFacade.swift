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

struct MediaFacade {
    
    static let storageRef = FIRStorage.storage().reference().child("Devices_Images")
    
    static func saveMedia(withId id: String, userName: String, media: UIImage, channelId: String, messageHandler: () -> Message) {
        if let uploadData = UIImagePNGRepresentation(media) {
            let uploadTask = storageRef.child("\(String(Date().timeIntervalSince1970)).png").put(uploadData, metadata: nil)
            
            uploadTask.observe(.success) { snapshot in
                let message = Message(userId: id,
                                      userName: userName,
                                      mediaUrl: (snapshot.metadata!.downloadURL()!.absoluteString),
                                      mediaItem: JSQPhotoMediaItem(image: media))
                
                ChatFacade.createMessage(channelId: channelId, message: message)
            }
        }
    }
    
    static func saveMediaWithProgress(id: String,
                                      userName: String,
                                      media: UIImage,
                                      presentIn viewController: JSQMessagesViewController,
                                      messageHandler: @escaping (Message) -> Void)
    {
   
        let progressView = UIProgressView(progressViewStyle: .default)
        var alertView = UIAlertController(title: "Please wait", message: "Uploading File", preferredStyle: .alert)
    
        progressView.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
        alertView.view.addSubview(progressView)
        
        if let uploadData = UIImagePNGRepresentation(media) {
            let uploadTask = storageRef.child("\(String(Date().timeIntervalSince1970)).png").put(uploadData, metadata: nil)
            
            DispatchQueue.main.async {
                viewController.present(alertView, animated: true)
            }
            uploadTask.observe(.progress) { snapshot in
                let progress = Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount)
                progressView.progress += progress
            }
            
            uploadTask.observe(.success) { snapshot in
                let message = Message(userId: id,
                                      userName: userName,
                                      mediaUrl: (snapshot.metadata!.downloadURL()!.absoluteString),
                                      mediaItem: JSQPhotoMediaItem(image: media))
                
                alertView.dismiss(animated: true)
                messageHandler(message)
            }
            
            uploadTask.observe(.failure) { snapshot in
                alertView.dismiss(animated: true)
                alertView = UIAlertController(title: "Error", message: "Something Whent wrong", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "accept", style: UIAlertActionStyle.default, handler: nil))
                DispatchQueue.main.async {
                    viewController.present(alertView, animated: true)
                }
            }
        }
    }
    
}
