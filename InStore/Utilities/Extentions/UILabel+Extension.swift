//
//  UILabel+Extension.swift
//  InStore
//
//  Created by mac on 6/4/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

extension UILabel {
    //    @IBInspectable var strikeThrough: Bool {
    //        get {
    //            return false
    //        }
    //        set (f) {
    //            guard let safeText = self.text else{return}
    //            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: safeText)
    //            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
    //        }
    //    }
    
    @IBInspectable var strikethrough : Bool {
        get{
            return false
        }
        set{
            if newValue {
                setStrikethrough(text: self.text!)
            }
        }
    }
    
    func setStrikethrough(text:String, color:UIColor = UIColor.gray) {
        let attributedText = NSAttributedString(string: text , attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: color])
        self.attributedText = attributedText
    }
}
