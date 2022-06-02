//
//  RepositoryProtocol.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    
    //remote functions
    func login() -> Observable<LoginResponse>?
    func register(customer: NewCustomer) -> Observable<NewCustomer>?
    func editAddresses(customer: NewCustomer) -> Observable<NewCustomer>?
    func deleteAddress(customer: NewCustomer,index:Int) -> Observable<NewCustomer>?
    func getOrders(userId:Int) -> Observable<Orders>?
    func addAddress(customer : NewCustomer) -> Observable<NewCustomer>?
    
    
    
    //local data functions
    func addToCart(product: Product)
    func fetchProductsFromCart() -> [CartProduct]?
    func deleteProductFromCart(deletedProductId: Int32)
    func editProductAmountInCart(productId : Int32, amount : Int16)
}
