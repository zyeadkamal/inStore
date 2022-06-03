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
    
    private init(localDataSource : LocalDataSourceProtocol = LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)!, apiClient : APIClientProtocol) {
        self.localDataSource = localDataSource
        self.apiClient = apiClient
    }
    
    static func shared(localDataSource: LocalDataSourceProtocol = LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)!, apiClient: APIClientProtocol) -> RepositoryProtocol? {
        if repo == nil {
            repo = Repository(localDataSource: localDataSource, apiClient: apiClient)
        }
        return repo
    }
    
    
    
    func login() -> Observable<LoginResponse>? {
        
        let customer = apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: ["email":"yalhwaaaaaaaay@gmail.com"],ofType: LoginResponse.self, json: ".json")
        
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
    
    
    func deleteAddress(customer: NewCustomer,index:Int) -> Observable<NewCustomer>? {
       
        let address = apiClient?.postRequest(fromEndpoint: EndPoint.customers , httpBody: nil, httpMethod: .delete, ofType: NewCustomer.self,json: "/\((customer.customer.id)!)/\((EndPoint.addresses))/\((customer.customer.addresses![index].id)!).json")
        
        return address
    }
    
    func getOrders(userId:Int) -> Observable<Orders>?{
       
        let orders = apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: [:],ofType: Orders.self,json: "/\(userId)/\(EndPoint.orders).json")
        
        return orders
    }
    
    func addAddress(address : Address) -> Observable<NewCustomer>? {
        var newAddress : Observable<NewCustomer>?
         do{
            let customer = CustomerAddress(addresses: [address])
            let putObject = PutAddress(customer: customer)
            let postBody = try JSONSerialization.data(withJSONObject: putObject.asDictionary(), options: .prettyPrinted)
            print(postBody)
            newAddress = apiClient?.postRequest(fromEndpoint: EndPoint.customers , httpBody: postBody, httpMethod: .put, ofType: NewCustomer.self,json: "/\((address.customer_id)!).json")
         }catch let error as NSError{
             print("\(error) can't add address, something error")
         }
        
         return newAddress
    }

    // admin/api/2021-10/customers/207119551/addresses.json
    func getAllAddresses(customerId: Int) -> Observable<CustomerAddress>? {
        let allAddresses = apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: [:],ofType: CustomerAddress.self,json: "/\(customerId)/\(EndPoint.addresses).json")
        
        return allAddresses
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
