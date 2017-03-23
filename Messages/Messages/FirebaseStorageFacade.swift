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
        let alertView = UIAlertController(title: "Please wait", message: "Need to download some files.", preferredStyle: .alert)
        let margin:CGFloat = 8.0
        let rect = CGRect(x: margin, y: 72, width: alertView.view.frame.width - margin * 2.0, height: 2)
        let progressView = UIProgressView(frame: rect)
        alertView.view.addSubview(progressView)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alertView, animated: true)
        
        if let uploadData = UIImagePNGRepresentation((mediaData.imgView.image)!) {
            let uploadTask = storageRef.child("\(mediaData.id!).png").put(uploadData, metadata: nil)
            
            uploadTask.observe(.progress) { snapshot in
                DispatchQueue.main.async {
                    viewController.present(alertView, animated: true)
                }
                progressView.progress  = 100.0 * Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount)
            }
            
            uploadTask.observe(.success) { snapshot in
                let message = Message(userId: id,
                                      userName: userName,
                                      mediaUrl: (snapshot.metadata!.downloadURL()!.absoluteString),
                                      mediaItem: nil)
                alertView.dismiss(animated: true)
                ChatFacade.createMessage(channelId: channelId, message: message)
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
