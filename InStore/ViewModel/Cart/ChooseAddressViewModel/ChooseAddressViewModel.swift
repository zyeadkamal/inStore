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
}


class ChooseAddressViewModel : ChooseAddressViewModelType{
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
     
    private func getAllAddresses(customerId : Int) -> Observable<CustomerAddress>{
         var addresses : Observable<CustomerAddress>?
         addresses = repo.getAllAddresses(customerId: customerId)
         return addresses!
         
     }
  
     
     func getData() {
         state = .loading

        getAllAddresses(customerId : 6246222299371).observe(on: MainScheduler.instance).subscribe( onNext: { address in
             self.addresses = address.addresses ?? []
             if(self.addresses.isEmpty){
                 self.state = .empty
             }else {
                 self.state = .populated
            }
            
         }, onError: { error in
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
            })
        
    }
}
