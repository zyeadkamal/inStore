//
//  ChooseAddressViewModel.swift
//  InStore
//
//  Created by sandra on 6/2/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol ChooseAddressViewModelType {
    func getData()
    var addressObservable: Observable<[Address]> {get set}
    var addressesList : [Address]{get set}
    var showLoadingObservable: Observable<State> { get set }
    var order : PostOrderRequest? {get set}
}


class ChooseAddressViewModel : ChooseAddressViewModelType{
    var order: PostOrderRequest?
    
    var addressesList : [Address] = [Address]()
    var addressObservable: Observable<[Address]>
    var myOrder : PostOrderRequest?
    var repo : RepositoryProtocol
    private var disposeBag = DisposeBag()
    private let addressSubject : BehaviorSubject = BehaviorSubject<[Address]>.init(value: [])
    private var addresses:[Address] = []{
        didSet{
            self.addressesList = addresses
            print(self.addressesList.count)
            addressSubject.onNext(addresses)
        }
    }
    
    var showLoadingObservable: Observable<State>
    private let showLoadingSubject : BehaviorSubject = BehaviorSubject<State>.init(value: .empty)
    
    var state: State = .empty {
        didSet {
            showLoadingSubject.onNext(state)
        }
    }
    
    init(repo:RepositoryProtocol, myOrder : PostOrderRequest){
        self.repo = repo
        self.myOrder = myOrder
        self.order = myOrder
        showLoadingObservable = showLoadingSubject.asObserver()
        addressObservable = addressSubject.asObservable()
    }
    
    private func getAllAddresses(customerId : Int) -> Observable<CustomerAddress>{
        var addresses : Observable<CustomerAddress>?
        addresses = repo.getAddresses(userId: customerId)
        return addresses!
        
    }
    
    
    func getData() {
        state = .loading
        
        getAllAddresses(customerId : MyUserDefaults.getValue(forKey: .id) as! Int).observe(on: MainScheduler.instance).subscribe( onNext: { address in
            self.addresses = address.addresses ?? []
            if(self.addresses.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }
            
        }, onError: { error in
            self.state = .error
        }).disposed(by: disposeBag)
        
    }
}
