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
    
    func login(email: String) -> Observable<LoginResponse>?
    func register(customer: NewCustomer) -> Observable<NewCustomer>?
    func editAddresses(customer: NewCustomer) -> Observable<NewCustomer>?
    func deleteAddress(customerId: Int,addressID:Int) -> Observable<NewCustomer>?
    func getOrders(userId:Int) -> Observable<Orders>?
    func addAddress(customer : NewCustomer) -> Observable<NewCustomer>?
    func getAddresses(userId:Int) -> Observable<CustomerAddress>?
    
    
    
    //local data functions
    func addToCart(product: Product)
    func fetchProductsFromCart() -> [CartProduct]?
    func deleteProductFromCart(deletedProductId: Int32)
    func editProductAmountInCart(productId : Int32, amount : Int16)
}
