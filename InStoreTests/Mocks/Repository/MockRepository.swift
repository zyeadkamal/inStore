//
//  MockRepository.swift
//  InStoreTests
//
//  Created by sandra on 6/23/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift
@testable import InStore

class MockRepository: RepositoryProtocol {
    
    private var localDataSource: LocalDataSourceProtocol?
    private var apiClient: APIClientProtocol?
    
    init(localDataSource : LocalDataSourceProtocol, apiClient: APIClientProtocol) {
        self.localDataSource = localDataSource
        self.apiClient = apiClient
    }
    func login(email: String) -> Observable<LoginResponse>? {
        return Observable<LoginResponse>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func register(customer: NewCustomer) -> Observable<NewCustomer>? {
        return Observable<NewCustomer>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func editAddresses(customer: NewCustomer) -> Observable<NewCustomer>? {
        return Observable<NewCustomer>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func deleteAddress(customerId: Int, addressID: Int) -> Observable<NewCustomer>? {
        return Observable<NewCustomer>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func getOrders(userId: Int) -> Observable<Orders>? {
        return Observable<Orders>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func addAddress(address: Address) -> Observable<NewCustomer>? {
        return Observable<NewCustomer>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func getAddresses(userId: Int) -> Observable<CustomerAddress>? {
        return apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: [:],ofType: CustomerAddress.self,json: "/\(userId)/\(EndPoint.addresses).json")
    }
    
    func getAllProducts() -> Observable<AllProducts>? {
        return Observable<AllProducts>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func getCodes(priceRuleID: String) -> Observable<DiscountCodes>? {
        return Observable<DiscountCodes>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func getBrands() -> Observable<Smart_collections>? {
        return Observable<Smart_collections>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func getDiscountCodes(priceRuleID: String) -> Observable<DiscountCodes>? {
        return Observable<DiscountCodes>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func postOrder(order: PostOrderRequest) -> Observable<PostOrderRequest>? {
        return Observable<PostOrderRequest>.create { (observer) -> Disposable in
            return Disposables.create()
        }
    }
    
    func addToCart(product: Product, customerName: String) {
        localDataSource?.addToCart(product: product, customerName: customerName)
    }
    
    func fetchProductsFromCart(customerName: String) -> Observable<[CartProduct]>? {
        return localDataSource?.fetchProductsFromCart(customerName: customerName)
    }
    
    func deleteProductFromCart(deletedProductId: Int64, customerName: String) {
        localDataSource?.deleteProductFromCart(deletedProductId: deletedProductId, customerName: customerName)
    }
    
    func editProductAmountInCart(productId: Int64, amount: Int16, customerName: String) {
        localDataSource?.editProductAmountInCart(productId: productId, amount: amount, customerName: customerName)
    }
    
    func fetchProductsFromFavourites(customerEmail: String) -> Observable<[Favourites]>? {
        return localDataSource?.fetchProductsFromFavourites(customerEmail: customerEmail)
    }
    
    func removeProductFromFavourites(customerEmail: String, deletedProductId: Int64) {
        localDataSource?.removeProductFromFavourites(customerEmail: customerEmail, deletedProductId: deletedProductId)
    }
    
    func addToFavourite(product: Product, customerEmail: String) {
        localDataSource?.addToFavourite(product: product, customerEmail: customerEmail)
    }
    
    func checkIfProductAddedToCart(customerEmail: String, productId: Int64) -> Bool {
        return localDataSource?.checkIfProductAddedToCart(customerEmail: customerEmail, productId: productId) ?? false
    }
}
