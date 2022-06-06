//
//  ProductDetailsViewModel.swift
//  InStore
//
//  Created by mac on 6/4/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    
    var product: Product
    var repo : RepositoryProtocol?
    init(product: Product, repo : RepositoryProtocol) {
        self.product = product
        self.repo = repo
    }
    
    
    func addProductToCart(product : Product , customerName:String) {
        repo?.addToCart(product: product ,customerName: customerName)
    }
    
    func addToFavourite(product: Product , customerEmail: String) {
        repo?.addToFavourite(product: product,customerEmail: customerEmail)
    }
    
    func removeProductFromFavourites(customerEmail: String, deletedProductId: Int64) {
        repo?.removeProductFromFavourites(customerEmail: customerEmail, deletedProductId: deletedProductId)
    }
    
}
