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
    
    
    func addProductToCart(product : Product) {
        repo?.addToCart(product: product)
    }
}
