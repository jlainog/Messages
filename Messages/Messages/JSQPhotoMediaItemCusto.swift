//
//  JSQPhotoMediaItemCusto.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/22/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import AlamofireImage

class JSQPhotoMediaItemCustom: JSQPhotoMediaItem {
    
    var imgView : UIImageView!
    var url     : String?
    
    override init!(maskAsOutgoing: Bool) {
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    init(withURL url: String, isOperator: Bool) {
        super.init()
        self.url                        = url
        appliesMediaViewMaskAsOutgoing  = (isOperator == true)
        let size                        = super.mediaViewDisplaySize()
        imgView                         = UIImageView()
        imgView.frame                   = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imgView.contentMode             = .scaleAspectFill
        imgView.clipsToBounds           = true
        imgView.backgroundColor         = UIColor.jsq_messageBubbleLightGray()
        
        let activityIndicator           = JSQMessagesMediaPlaceholderView.withActivityIndicator()
        activityIndicator?.frame        = imgView.frame
        imgView.addSubview(activityIndicator!)
        
        JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: self.imgView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
        
        let downloader = ImageDownloader()
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        downloader.download(urlRequest) { response in
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            let image = response.result.value
            if  image != nil{
                
                activityIndicator?.removeFromSuperview()
                self.imgView.image = image
            }
            self.imgView.image = image
        }

    }
    
    override func mediaView() -> UIView! {
        return imgView
    }
    
    override func mediaViewDisplaySize() -> CGSize {
        return imgView.frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
