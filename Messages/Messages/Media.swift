//
//  media.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController
import AlamofireImage
import Alamofire
import UIKit

struct MediaImage {
    
    var id: String?
    var imgView: UIImageView
    
    init(id: String, image: UIImage?) {
        self.id = id
        self.imgView = UIImageView()
        imgView.image = image
        
    }
    
    func toDic() -> [String: Any] {
        return ["content": DataCoder.base64(fromImage: imgView.image)]
    }
}

extension MediaImage {
    
    func toMediaItem() -> JSQMessageMediaData! {
        return JSQPhotoMediaItem(image: self.imgView.image)
    }
    
}
