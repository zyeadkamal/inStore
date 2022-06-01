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
    
    func login() -> Observable<LoginResponse>?
    func register(customer: NewCustomer) -> Observable<NewCustomer>?
    func editAddresses(customer: NewCustomer) -> Observable<NewCustomer>?
    func deleteAddress(customer: NewCustomer,index:Int) -> Observable<NewCustomer>?
    func getOrders(userId:Int) -> Observable<Orders>?
}
