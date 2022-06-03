//
//  CartScreenViewModel.swift
//  InStore
//
//  Created by sandra on 6/3/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

protocol CartViewModelType {
    func updateProductAmount(productId : Int32, amount: Int16)
    func fetchAllSavedProducts() -> [CartProduct]?
}


class CartViewModel: CartViewModelType {
     
    var repo : RepositoryProtocol?
    
    init(repo : RepositoryProtocol) {
        self.repo = repo
    }
    
    func updateProductAmount(productId : Int32, amount: Int16) {
        repo?.editProductAmountInCart(productId: productId, amount: amount)
    }
    
    func fetchAllSavedProducts() -> [CartProduct]? {
        return repo?.fetchProductsFromCart()
    }
    
   
    
}
