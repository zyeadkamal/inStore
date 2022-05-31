//
//  WishlistTableViewCell.swift
//  InStore
//
//  Created by sandra on 5/29/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {

    //MARK: -- IBOutlist
    @IBOutlet weak var wishlistCellImg: UIImageView!
    @IBOutlet weak var wishlistProductTitle: UILabel!
    @IBOutlet weak var wishlistProductPrice: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    
    //MARK: -- Properties
    
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: -- IBActions
    @IBAction func didPressAddToCart(_ sender: UIButton) {
    }
    //MARK: -- Functions
    
}
