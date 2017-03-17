//
//  DataCoder.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/17/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import UIKit

struct DataCoder {
    
    static func base64(fromImage image : UIImage?) -> String? {
        guard image != nil, let imageData = UIImagePNGRepresentation(image!) else {return nil}
        let strBase64 = imageData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return strBase64
    }
    
    static func Image(fromBase64 base64 : String? ) -> UIImage? {
        guard base64 != "", base64 != nil else {return nil}
        let dataDecoded : NSData = NSData(base64Encoded: base64!, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage : UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
}
