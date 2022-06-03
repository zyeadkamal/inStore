//
//  MyAccountViewModel.swift
//  InStore
//
//  Created by Mohamed Ahmed on 02/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

import RxSwift


protocol MyAccountViewModelType{
    func getData()
    var orderObservable: Observable<[MockOrder]> {get set}
    var orderList : [MockOrder]{get}
    var showLoadingObservable: Observable<State> { get set }
    
}


class MyAccountViewModel: MyAccountViewModelType{
    
    private var bag = DisposeBag()
    private(set) var orderList : [MockOrder] = [MockOrder]()
    private var repo : RepositoryProtocol
    var orderObservable: Observable<[MockOrder]>
    private let orderSubject : BehaviorSubject = BehaviorSubject<[MockOrder]>.init(value: [])
    private var orders:[MockOrder] = []{
        didSet{
            self.orderList = orders
            orderSubject.onNext(orders)
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
        orderObservable = orderSubject.asObservable()
    }
    
    func getOrders(userId:Int) -> Observable<Orders>{
        var orders : Observable<Orders>?
        orders = repo.getOrders(userId: userId)
        return orders!
    }
    
    
    func getData() {
        state = .loading
        getOrders(userId:6232280301803).observe(on: MainScheduler.instance).subscribe(onNext: { (orders) in
            self.orders = orders.orders
            if(orders.orders.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }
        }, onError: { (error) in
            
            self.state = .error
            }).disposed(by: bag)
        
    }
    
    
}

