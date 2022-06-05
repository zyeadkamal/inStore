//
//  ProductPhotosCollectionViewCell.swift
//  InStore
//
//  Created by mac on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Kingfisher

class ProductPhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    
    var productImage: String?{
        didSet{
            if let safeImage = productImage {
                productImageView.kf.setImage(with: URL(string: safeImage))
            }
        }
    }
}
