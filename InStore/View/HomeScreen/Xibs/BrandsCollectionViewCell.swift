//
//  BrandsCollectionViewCell.swift
//  InStore
//
//  Created by Mohamed Ahmed on 26/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Kingfisher

class BrandsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandImage: UIImageView!
    
    @IBOutlet weak var brandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ brand :Brand){
        if (brand.name == "PUMA"){
            brandImage.image =  #imageLiteral(resourceName: "Puma-logo")
        }
        else {
            brandImage.kf.setImage(with: URL(string:brand.image?.src ?? "https://banksiafdn.com/wp-content/uploads/2019/10/placeholde-image.jpg" ))
        }
        brandName.text = brand.name
    }
    
}
