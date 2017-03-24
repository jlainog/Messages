//
//  ChatImagePickeViewController.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/16/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit

class ChatImagePickeViewController: UIImagePickerController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowsEditing = true
        self.sourceType = .photoLibrary
        self.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    }
    
}

class ChatPhotoPickeViewController: UIImagePickerController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowsEditing = true
        self.sourceType = .camera
        self.cameraCaptureMode = .photo
        self.modalPresentationStyle = .fullScreen
    }
}


