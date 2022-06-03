//
//  Repository.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

class Repository: RepositoryProtocol {
    
    private static var repo: RepositoryProtocol?
    private var localDataSource: LocalDataSourceProtocol?
    private var apiClient: APIClientProtocol?
    
    private init(localDataSource : LocalDataSourceProtocol, apiClient : APIClientProtocol) {
        self.localDataSource = localDataSource
        self.apiClient = apiClient
    }
    
    static func shared(localDataSource: LocalDataSourceProtocol, apiClient: APIClientProtocol) -> RepositoryProtocol? {
        if repo == nil {
            repo = Repository(localDataSource: localDataSource, apiClient: apiClient)
        }
        return repo
    }
    
    
    
    func login(email: String) -> Observable<LoginResponse>? {
        
        let customer = apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: ["email":email],ofType: LoginResponse.self, json: ".json")
        
        return customer
    }
    
    
    func register(customer: NewCustomer) -> Observable<NewCustomer>? {
        
        var newCustomer : Observable<NewCustomer>?
        do{
            let postBody = try JSONEncoder().encode(customer)
            newCustomer = apiClient?.postRequest(fromEndpoint: EndPoint.customers , httpBody: postBody, httpMethod: .post, ofType: NewCustomer.self, json: ".json")
        }
        catch{}
        
        return newCustomer
    }
    
    
    func editAddresses(customer: NewCustomer) -> Observable<NewCustomer>? {
        
        var address : Observable<NewCustomer>?
        do{
            let postBody = try JSONEncoder().encode(customer)
            address = apiClient?.postRequest(fromEndpoint: EndPoint.customers , httpBody: postBody, httpMethod: .put, ofType: NewCustomer.self,json: "/\((customer.customer.id)!).json")
        }catch{}
       
        return address
    }
    
    
    func deleteAddress(customerId: Int,addressID:Int) -> Observable<NewCustomer>? {
       
        let address = apiClient?.postRequest(fromEndpoint: EndPoint.customers , httpBody: nil, httpMethod: .delete, ofType: NewCustomer.self,json: "/\(customerId)/\((EndPoint.addresses))/\(addressID).json")
    
        return address
    }
    
    func getOrders(userId:Int) -> Observable<Orders>?{
       
        let orders = apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: [:],ofType: Orders.self,json: "/\(userId)/\(EndPoint.orders).json")
        
        return orders
    }
    
    func addAddress(customer: NewCustomer) -> Observable<NewCustomer>? {
        var address : Observable<NewCustomer>?
         do{
             let postBody = try JSONEncoder().encode(customer)
             address = apiClient?.postRequest(fromEndpoint: EndPoint.customers , httpBody: postBody, httpMethod: .put, ofType: NewCustomer.self,json: "/\((customer.customer.id)!).json")
         }catch{}
        
         return address
    }
    //customers/6246222299371/addresses.json
    
    func getAddresses(userId:Int) -> Observable<CustomerAddress>?{
       
        let addresses = apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: [:],ofType: CustomerAddress.self,json: "/\(userId)/\(EndPoint.addresses).json")
        
        return addresses
    }
    
    func addToCart(product: Product) {
        localDataSource?.addToCart(product: product)
    }
    
    func fetchProductsFromCart() -> [CartProduct]? {
        return localDataSource?.fetchProductsFromCart()
    }
    
    func deleteProductFromCart(deletedProductId: Int32) {
        localDataSource?.deleteProductFromCart(deletedProductId: deletedProductId)
    }
    
    func editProductAmountInCart(productId: Int32, amount: Int16) {
        localDataSource?.editProductAmountInCart(productId: productId, amount: amount)
    }
}