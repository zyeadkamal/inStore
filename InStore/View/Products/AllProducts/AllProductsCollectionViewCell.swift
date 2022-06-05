//
//  AllProductsCollectionViewCell.swift
//  InStore
//
//  Created by mac on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Kingfisher

class AllProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productPrevPriceLabel: UILabel!
    @IBOutlet weak var productRateLabel: UILabel!
    
    @IBOutlet weak var addToFavouriteButton: UIButton!
    var addToFavouriteClosure: (() -> ())?
}

//MARK:- IBActions
extension AllProductsCollectionViewCell {
    @IBAction func addToFavouritesButtonPressed(_ sender: UIButton) {
        addToFavouriteClosure?()
    }
}

//MARK:- Setup Views
extension AllProductsCollectionViewCell {
    func setUpCell(product: Product) {
        if product.images.count != 0 {
            productImageView.kf.setImage(with: URL(string: product.images[0].src))
        }
        productNameLabel.text = product.title
        productPriceLabel.text = "$\(product.varients?[0].price ?? "399.9")"
        productPrevPriceLabel.text = "$\((Double(product.varients?[0].price ?? "200.0")!) + 49.9)"
        productRateLabel.text = "\(Constants.productRatings[Int.random(in: 0..<7)])"
        if Constants.favoriteProducts.contains(product){
            addToFavouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            addToFavouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
