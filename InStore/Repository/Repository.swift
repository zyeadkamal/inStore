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
    
    func postOrder(order : PostOrderRequest) -> Observable<PostOrderRequest>?{
        var newOrder: Observable<PostOrderRequest>?
        do{
            let postBody = try JSONSerialization.data(withJSONObject: order.asDictionary(), options: .prettyPrinted)
            newOrder = apiClient?.postRequest(fromEndpoint: EndPoint.orders, httpBody: postBody, httpMethod: .post, ofType: PostOrderRequest.self, json: ".json")
        }catch let error as NSError{
            print("\(error) can't add order, something error")
        }
        return newOrder
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

    //customers/6246222299371.json
    
    func getAddresses(userId:Int) -> Observable<CustomerAddress>?{
       
        let addresses = apiClient?.getRequest(fromEndpoint: EndPoint.customers, httpMethod: .get, parameters: [:],ofType: CustomerAddress.self,json: "/\(userId)/\(EndPoint.addresses).json")
        
        return addresses
    }
    
    
    //https://4a798eacca0d39cc2048369ad2025b47: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@mad-sv.myshopify.com/admin/api/2022-04/price_rules/1185721155819/discount_codes.json
    func getDiscountCodes(priceRuleID: String) -> Observable<DiscountCodes>?{
        
        let discountCodes = apiClient?.getRequest(fromEndpoint: EndPoint.price_rules, httpMethod: .get, parameters: [:], ofType: DiscountCodes.self, json: "/\(priceRuleID)/\(EndPoint.discount_codes).json")
        return discountCodes
        
    }
    
    
    func addToCart(product: Product) {
        localDataSource?.addToCart(product: product)
    }
    
    func fetchProductsFromCart() -> Observable<[CartProduct]>? {
        return localDataSource?.fetchProductsFromCart()
    }
    
    func deleteProductFromCart(deletedProductId: Int64) {
        localDataSource?.deleteProductFromCart(deletedProductId: deletedProductId)
    }
    
    func editProductAmountInCart(productId: Int64, amount: Int16) {
        localDataSource?.editProductAmountInCart(productId: productId, amount: amount)
    }
}
