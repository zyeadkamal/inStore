
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
    func getData()
    var addressObservable: Observable<[Address]> {get set}
    var addressesList : [Address]{get set}
    var showLoadingObservable: Observable<State> { get set }
    func deleteData( index:Int)
}

class MyAddressViewModel: MyAddressViewModelType{
    
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
    
    func deleteData( index:Int){
       // state = .loading
        
        deleteAddress(userId:6246222299371, index:index).observe(on: MainScheduler.instance).subscribe { _ in
            
            
        } onError: { error in
            switch error {
            case ApiError.conflict:
                print("Conflict error")
            case ApiError.forbidden:
                print("Forbidden error")
            case ApiError.notFound:
                print("Not found error")
            default:
                print("Unknown error:", error.localizedDescription)
            }
            //self.state = .error
            self.addresses.remove(at: index)

            if(self.addresses.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }
        }

    }
    
    
    
    func getData() {
        state = .loading
        getAddress(userId:6246222299371).observe(on: MainScheduler.instance).subscribe { address in
            self.addresses = address.addresses ?? []
            if(self.addresses.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }

        } onError: { error in
            switch error {
            case ApiError.conflict:
                print("Conflict error")
            case ApiError.forbidden:
                print("Forbidden error")
            case ApiError.notFound:
                print("Not found error")
            default:
                print("Unknown error:", error.localizedDescription)
            }
            self.state = .error
        }
        
    }
    
    
}
