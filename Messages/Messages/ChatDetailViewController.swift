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

    @IBOutlet var mediaContainer: UIView!
    var messageType: MessageType?
    var image: UIImage?
    var URLImage: URL?
    private var imgViewDetail: UIImageView?
    private let defaultMedia = UIImage(contentsOfFile: "placeholder")

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        imgViewDetail!.af_setImage(
            withURL: URLImage!,
            placeholderImage: UIImage(named: "grey-image-placeholder"),
            filter: nil,
            imageTransition: .crossDissolve(0.2))
        view.addSubview(imgViewDetail!)
    }
    
}
