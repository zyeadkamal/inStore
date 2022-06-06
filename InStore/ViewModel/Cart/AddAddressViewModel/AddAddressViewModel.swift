//
//  AddAddressViewModel.swift
//  InStore
//
//  Created by sandra on 6/2/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol AddAddressViewModelType {
    var order : PostOrderRequest? {get set}
    func addAddressForCurrentCustomer(address : Address) -> Observable<NewCustomer>?
}


class AddAddressViewModel : AddAddressViewModelType{
    
    private var repo : RepositoryProtocol?
    var myOrder : PostOrderRequest?
    var order: PostOrderRequest?
    
    init(repo : RepositoryProtocol, myOrder : PostOrderRequest) {
        self.repo = repo
        self.myOrder = myOrder
        self.order = myOrder
    }
    
    
    func addAddressForCurrentCustomer(address : Address) -> Observable<NewCustomer>? {
        repo?.addAddress(address: address)
    }
    
}
