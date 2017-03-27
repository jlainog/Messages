//
//  ChatDetailViewController.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/27/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit

class ChatDetailViewController: UIViewController {

    @IBOutlet weak var detailImgView: UIImageView!
    var image: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailImgView.image = image
    }
    
}
