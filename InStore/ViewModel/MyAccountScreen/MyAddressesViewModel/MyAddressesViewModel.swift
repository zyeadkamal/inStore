
//
//  MyAccountViewModel.swift
//  InStore
//
//  Created by Mohamed Ahmed on 02/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

import RxSwift


protocol MyAddressViewModelType{
    func getData(userId:Int)
    var addressObservable: Observable<[Address]> {get set}
    var addressesList : [Address]{get set}
    var showLoadingObservable: Observable<State> { get set }
    func deleteData( index:Int,userId:Int)
}

class MyAddressViewModel: MyAddressViewModelType{
    
    private let bag = DisposeBag()
    var addressesList : [Address] = [Address]()
    private var repo : RepositoryProtocol
    var addressObservable: Observable<[Address]>
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
    
    init(repo:RepositoryProtocol){
        self.repo = repo
        showLoadingObservable = showLoadingSubject.asObserver()
        addressObservable = addressSubject.asObservable()
    }
    
    private func getAddress(userId:Int) -> Observable<CustomerAddress>{
        var addresses : Observable<CustomerAddress>?
        addresses = repo.getAddresses(userId: userId)
        return addresses!
        
    }
    
   private func deleteAddress(userId :Int, index:Int ) -> Observable<NewCustomer>{
        var addresses : Observable<NewCustomer>?
        print(self.addressesList[index].id!)
        addresses = repo.deleteAddress(customerId: userId, addressID: self.addressesList[index].id!)
        return addresses!
        
    }
    
    func deleteData( index:Int , userId:Int){
       // state = .loading
        
        deleteAddress(userId:userId, index:index).observe(on: MainScheduler.instance).subscribe(onError: {
            [weak self](error) in
            guard let self = self else{return}
            //self.state = .error
            self.addresses.remove(at: index)

            if(self.addresses.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }
            }).disposed(by: bag)

    }
    
    
    
    func getData(userId:Int) {
        state = .loading
        getAddress(userId:userId).observe(on: MainScheduler.instance).subscribe(onNext: {   [weak self](address) in
            guard let self = self else{return}
            self.addresses = address.addresses ?? []
            if(self.addresses.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }
        }, onError: { (error) in
            self.state = .error
            }).disposed(by: bag)
        
    }
    
    
}


