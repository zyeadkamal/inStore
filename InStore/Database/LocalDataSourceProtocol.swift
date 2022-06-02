//
//  LocalDataSourceProtocol.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import CoreData

protocol LocalDataSourceProtocol {
    // cart functions
    func addToCart(product: Product)
    func fetchProductsFromCart() -> [CartProduct]?
    func deleteProductFromCart(deletedProductId: Int32)
    func editProductAmountInCart(productId : Int32, amount : Int16)
}
