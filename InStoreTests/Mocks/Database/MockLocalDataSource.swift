//
//  MockLocalDataSource.swift
//  InStoreTests
//
//  Created by sandra on 6/23/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift
@testable import InStore

class MockLocalDataSource: LocalDataSourceProtocol {
    
    var cartProductsArr : [CartProduct] = []
    var favouritesArr : [Favourites] = []
    
    init() {
        
    }
    
    func addToCart(product: Product, customerName: String) {
        let cartProduct = CartProduct()
        cartProduct.productId = Int64(product.id)
        cartProduct.productTitle = product.title
        cartProduct.productImg = product.images[0].src
        cartProduct.productPrice = product.varients?[0].price
        cartProduct.productAmount = 1
        cartProduct.customerEmail = customerName
        cartProduct.vartiantId = Int64(product.varients?[0].id ?? 0)
        cartProductsArr.append(cartProduct)
    }
    
    func fetchProductsFromCart(customerName: String) -> Observable<[CartProduct]>? {
        
        return Observable<[CartProduct]>.create { (observer) -> Disposable in
            observer.onNext(self.cartProductsArr)
            
            return Disposables.create()
        }
    }
    
    func deleteProductFromCart(deletedProductId: Int64, customerName: String) {
        for index in 0..<cartProductsArr.count{
            if deletedProductId == cartProductsArr[index].productId{
                cartProductsArr.remove(at: index)
            }
        }
    }
    
    func editProductAmountInCart(productId: Int64, amount: Int16, customerName: String) {
        for index in 0..<cartProductsArr.count{
            if productId == cartProductsArr[index].productId{
                cartProductsArr[index].productAmount = amount
            }
        }
    }
    
    func fetchProductsFromFavourites(customerEmail: String) -> Observable<[Favourites]>? {
        return Observable<[Favourites]>.create { (observer) -> Disposable in
            observer.onNext(self.favouritesArr)
            
            return Disposables.create()
        }
    }
    
    func removeProductFromFavourites(customerEmail: String, deletedProductId: Int64) {
        for index in 0..<favouritesArr.count{
            if deletedProductId == favouritesArr[index].id{
                favouritesArr.remove(at: index)
            }
        }
    }
    
    func addToFavourite(product: Product, customerEmail: String) {
        let favouriteProduct = Favourites()
        favouriteProduct.id = Int64(product.id)
        favouriteProduct.title = product.title
        favouriteProduct.image = product.images[0].src
        favouriteProduct.price = product.varients?[0].price
        favouriteProduct.descreption = product.description
        favouriteProduct.vendor = product.vendor
        favouriteProduct.productType = product.productType
        favouriteProduct.customerEmail = customerEmail
        favouritesArr.append(favouriteProduct)
    }
    
    func checkIfProductAddedToCart(customerEmail: String, productId: Int64) -> Bool? {
        for index in 0..<favouritesArr.count{
            if productId == favouritesArr[index].id{
                return true
            }
        }
        return false
    }
}
