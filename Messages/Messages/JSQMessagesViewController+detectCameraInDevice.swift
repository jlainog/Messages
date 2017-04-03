//
//  File.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/24/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import JSQMessagesViewController

extension JSQMessagesViewController {
    
    func detectCameraInDevice(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
}
