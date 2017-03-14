//
//  UITextField+Shake.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/13/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.8
        animation.values = [-10.0, 10.0, -10.0, 10.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
