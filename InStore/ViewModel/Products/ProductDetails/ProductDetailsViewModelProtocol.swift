//
//  ProductDetailsViewModelProtocol.swift
//  InStore
//
//  Created by mac on 6/4/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

protocol ProductDetailsViewModelProtocol {
    var product: Product{get set}
    func addProductToCart(product : Product ,customerName:String)
    func addToFavourite(product: Product , customerEmail: String)
    func removeProductFromFavourites(customerEmail: String, deletedProductId: Int64)
    func deleteProductFromCart(deletedProductId: Int64,customerName:String)
    func transformProduct(product: Product) -> CartProduct
    
}
