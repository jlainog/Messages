//
//  ChatDetailViewController.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/27/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit
import AlamofireImage

class ChatDetailViewController: UIViewController {

    @IBOutlet weak var mediaContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var messageType: MessageType?
    var image: UIImage?
    var URLImage: URL?
    private var imgViewDetail: UIImageView?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        switch messageType! {
        case .media:
            setImage()
        case .text:
            return
        }
    }
    
    func setImage() {
        imgViewDetail = UIImageView()
        imgViewDetail?.contentMode = .scaleAspectFit;
        imgViewDetail?.frame = view.bounds
        
        guard let image = self.image else {
            imgViewDetail?.af_setImage(withURL: URLImage!) { _ in
                self.activityIndicator.stopAnimating()
            }
            return self.view.addSubview(self.imgViewDetail!)
        }
        
        imgViewDetail?.image = image
        self.activityIndicator.stopAnimating()
        self.view.addSubview(imgViewDetail!)
    }
    
}
