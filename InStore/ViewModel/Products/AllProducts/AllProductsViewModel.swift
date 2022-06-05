//
//  AllProductsViewModel.swift
//  InStore
//
//  Created by mac on 6/3/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

class AllProductsViewModel: AllProductsViewModelProtocol {
    
    private var bag = DisposeBag()
    private var repository: RepositoryProtocol?
    
    var allProductsObservable: Observable<[Product]?>
    private var allProductsSubject: PublishSubject<[Product]?> = PublishSubject()
    var allProducts: [Product]?{
        didSet{
            allProductsSubject.onNext(allProducts)
        }
    }
    
    var showLoadingObservable: Observable<State>
    private let showLoadingSubject : BehaviorSubject = BehaviorSubject<State>.init(value: .empty)
    var state: State = .empty {
        didSet {
            showLoadingSubject.onNext(state)
        }
    }
    
    init(repository: RepositoryProtocol?) {
        self.repository = repository
        self.allProductsObservable = allProductsSubject.asObservable()
        showLoadingObservable = showLoadingSubject.asObserver()
    }
    
    
    func getAllProducts() {
        self.state = .loading
        repository?.getAllProducts()?
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (allProducts) in
                print(Constants.favoriteProducts.count)
                if allProducts.products.count == 0{
                    self?.state = .empty
                }else {
                    self?.state = .populated
                    self?.allProducts = allProducts.products
                }
            }, onError: {[weak self] (error) in
                self?.state = .error
            }).disposed(by: bag)
    }
    
    
}
