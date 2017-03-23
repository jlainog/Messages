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

    static func saveMedia(withId id: String, userName: String, media: UIImage, channelId: String) {
 
        let mediaData = MediaImage.init(id: String(Date().timeIntervalSince1970), image: media)
        
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
    
    static func saveMediaWithProgress(id: String, userName: String, media: UIImage, channelId: String, presentIn viewController: JSQMessagesViewController) {
   
        let mediaData = MediaImage.init(id: String(Date().timeIntervalSince1970), image: media)
        var alertView = UIAlertController(title: "Please wait", message: "Uploading File", preferredStyle: .alert)
        let progressView = UIProgressView(progressViewStyle: .default)
    
        progressView.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
        alertView.view.addSubview(progressView)
        
        if let uploadData = UIImagePNGRepresentation((mediaData.imgView.image)!) {
            let uploadTask = storageRef.child("\(mediaData.id!).png").put(uploadData, metadata: nil)
            
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
                                      mediaItem: nil)
                alertView.dismiss(animated: true)
                ChatFacade.createMessage(channelId: channelId, message: message)
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
    
    static func fetchMedia(atURL url: String, completionHandler: @escaping (UIImage) -> Void) {
        let storageRef = FIRStorage.storage().reference(forURL: url)
        
        storageRef.data(withMaxSize: INT64_MAX) { (data, error) in
            guard let validData = data else {
                return
            }
            
            storageRef.metadata() { (metadata, error) in
                completionHandler(UIImage(data: validData)!)
            }
        }
    }

}
