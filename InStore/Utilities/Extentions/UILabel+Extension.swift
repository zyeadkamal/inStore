//
//  UILabel+Extension.swift
//  InStore
//
//  Created by mac on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

extension UILabel {
    
   @IBInspectable var strikethrough : String {
        get{
            return ""
        }
        set{
            setStrikethrough(text: newValue)
        }
    }
    
    func setStrikethrough(text:String, color:UIColor = UIColor.gray) {
        let attributedText = NSAttributedString(string: text , attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: color])
        self.attributedText = attributedText
    }
}

