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
    
    var addToCart: () -> Void =  {}
    var isAddedToCart = false

    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }
    
    func changeButtonUI(){
        if (isAddedToCart){
            addToCartBtn.setTitle("Remove From Cart", for: .normal)
        }
        else {
            addToCartBtn.setTitle("Add To Cart", for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(favourite:Favourites)
    {
        wishlistProductPrice.text = favourite.price
        wishlistProductTitle.text = favourite.title
        wishlistCellImg.kf.setImage(with: URL(string:favourite.image ?? "https://banksiafdn.com/wp-content/uploads/2019/10/placeholde-image.jpg" ))
    }

    
    //MARK: -- IBActions
    @IBAction func didPressAddToCart(_ sender: UIButton) {
        addToCart()
    }
    //MARK: -- Functions
    
}
