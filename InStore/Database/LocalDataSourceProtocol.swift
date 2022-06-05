//
//  LocalDataSourceProtocol.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

protocol LocalDataSourceProtocol {
    // cart functions
    func addToCart(product: Product)
    func fetchProductsFromCart() -> Observable<[CartProduct]>?
    func deleteProductFromCart(deletedProductId: Int64)
    func editProductAmountInCart(productId : Int64, amount : Int16)
}
