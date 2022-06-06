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
    func addToCart(product: Product,customerName:String)
    func fetchProductsFromCart(customerName:String) -> Observable<[CartProduct]>?
    func deleteProductFromCart(deletedProductId: Int64,customerName:String)
    func editProductAmountInCart(productId : Int64, amount : Int16,customerName:String)
    func fetchProductsFromFavourites(customerEmail:String) -> Observable<[Favourites]>?
    func removeProductFromFavourites(customerEmail:String,deletedProductId: Int64)
    func addToFavourite(product: Product , customerEmail: String)
    func checkIfProductAddedToCart(customerEmail:String, productId :Int64)->Bool?
    
}

