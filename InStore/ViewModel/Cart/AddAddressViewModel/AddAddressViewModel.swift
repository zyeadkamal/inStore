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
    var countryTFPublishSubject : PublishSubject<String> {get set}
    var cityTFPublishSubject : PublishSubject<String> {get set}
    var addressTFPublishSubject : PublishSubject<String> {get set}
    var phoneTFPublishSubject : PublishSubject<String> {get set}
    var order : PostOrderRequest? {get set}
    func validateAddress() -> Observable<Bool>
    func addAddressForCurrentCustomer(address : Address) -> Observable<NewCustomer>?
}


class AddAddressViewModel : AddAddressViewModelType{
    
    //country, city, address, phone
    var countryTFPublishSubject = PublishSubject<String>()
    var cityTFPublishSubject = PublishSubject<String>()
    var addressTFPublishSubject = PublishSubject<String>()
    var phoneTFPublishSubject = PublishSubject<String>()
    private var repo : RepositoryProtocol?
    var myOrder : PostOrderRequest?
    var order: PostOrderRequest?
    
    init(repo : RepositoryProtocol, myOrder : PostOrderRequest) {
        self.repo = repo
        self.myOrder = myOrder
        self.order = myOrder
    }
    
    func validateAddress() -> Observable<Bool> {
        return Observable.combineLatest(countryTFPublishSubject.asObserver().startWith(""), cityTFPublishSubject.asObserver().startWith(""), addressTFPublishSubject.asObserver().startWith(""), phoneTFPublishSubject.asObserver().startWith("")).map { (country, city, address, phone) in
            return !country.isEmpty && !city.isEmpty && !address.isEmpty && !phone.isEmpty
        }.startWith(false)
    }
    
    func addAddressForCurrentCustomer(address : Address) -> Observable<NewCustomer>? {
        repo?.addAddress(address: address)
    }
    
}
