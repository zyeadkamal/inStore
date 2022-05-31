//
//  SuggestedCollectionViewCell.swift
//  InStore
//
//  Created by sandra on 5/30/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class SuggestedCollectionViewCell: UICollectionViewCell {

    //MARK: -- IBoutlets
    @IBOutlet weak var suggestedImg: UIImageView!
    @IBOutlet weak var addToFavBtn: UIButton!
    @IBOutlet weak var suggestedProductTitle: UILabel!
    @IBOutlet weak var suggestedProductPrice: UILabel!
    @IBOutlet weak var suggestedProductDesc: UILabel!
    @IBOutlet weak var productRatting: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var staffPickTitle: UILabel!
    
    //MARK: -- Properties
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: -- IBActions
    
    @IBAction func didPressAddToFav(_ sender: Any) {
    }
    //MARK: -- Functions
    
}
