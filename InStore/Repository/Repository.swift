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
    
    
}
