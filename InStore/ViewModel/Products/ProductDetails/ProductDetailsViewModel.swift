//
//  ProductDetailsViewModel.swift
//  InStore
//
//  Created by mac on 6/4/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import CoreData

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    
    
    private var managedContext : NSManagedObjectContext?
    var product: Product
    var repo : RepositoryProtocol?
    init(product: Product, repo : RepositoryProtocol, managedContext : NSManagedObjectContext) {
        self.product = product
        self.repo = repo
        self.managedContext = managedContext
    }
    
    
    func addProductToCart(product : Product , customerName:String) {
        guard let repo = repo else {
            return
        }

        if(!repo.checkIfProductAddedToCart(customerEmail: customerName, productId: Int64(product.id))){
            repo.addToCart(product: product ,customerName: customerName)
        }
        
    }
    
    func addToFavourite(product: Product , customerEmail: String) {
        repo?.addToFavourite(product: product,customerEmail: customerEmail)
    }
    
    func removeProductFromFavourites(customerEmail: String, deletedProductId: Int64) {
        repo?.removeProductFromFavourites(customerEmail: customerEmail, deletedProductId: deletedProductId)
    }
    
    func deleteProductFromCart(deletedProductId: Int64, customerName: String) {
        repo?.deleteProductFromCart(deletedProductId: deletedProductId, customerName: customerName)
    }
    
    func transformProduct(product: Product) -> CartProduct {
        let cartEntity = CartProduct(context: self.managedContext!)
        cartEntity.productId = Int64(product.id)
        cartEntity.productTitle = product.title
        cartEntity.productImg = product.images[0].src
        cartEntity.productPrice = product.varients?[0].price
        cartEntity.productAmount = 1
        cartEntity.customerEmail = "customerName"
        cartEntity.vartiantId = Int64(product.varients?[0].id ?? 0)
        return cartEntity
    }
}
