//
//  UITextField+Extension.swift
//  InStore
//
//  Created by mac on 5/26/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable var padding_left: CGFloat {
           get {
               return 0
           }
           set (f) {
               layer.sublayerTransform = CATransform3DMakeTranslation(f, 0, 0)
           }
       }
}
