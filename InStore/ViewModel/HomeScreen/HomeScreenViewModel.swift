//
//  HomeScreenViewModel.swift
//  InStore
//
//  Created by Mohamed Ahmed on 03/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeScreenViewModelType{
    func loadData()
    var ads : [DiscountCode]?{get}
    var brands : [Smart_collection]?{get}
    var showLoadingObservable: Observable<State> { get set }
    
}
class HomeScreenViewModel : HomeScreenViewModelType{
    
    
    private var bag = DisposeBag()
    
    var adsList : [DiscountCode]?{
        didSet {
            self.ads = adsList
        }
    }
    var ads : [DiscountCode]?
    
    
    var brandsList : [Smart_collection]?{
        didSet {
            self.brands = brandsList
        }
    }
    var brands : [Smart_collection]?
    
    private(set) var homeResponseList : HomeResponse?
    private var repo : RepositoryProtocol
    
    
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
        
    }
    
    func getOrders(userId:Int) -> Observable<Orders>?{
        var orders : Observable<Orders>?
        orders = repo.getOrders(userId: userId)
        return orders
    }
    
    func getAds()->Observable<DiscountCodes>?{
        let discount = repo.getDiscountCodes(priceRuleID: "1185721155819")
        return discount
    }
    func getBrands() -> Observable<Smart_collections>?{
        let brands = repo.getBrands()
        return brands
    }
    
    
    
    
    func loadData() {
        
        
//                state = .loading
////                getAds()!.observe(on: MainScheduler.instance).subscribe(onNext: { (ads) in
////                    self.adsList = ads.discount_codes
////                    print(self.adsList)
////
////
////                    if(self.adsList!.isEmpty){
////                        self.state = .empty
////                    }else {
////                        self.state = .populated
////                    }
////                }, onError: { (error) in
////                   // self.state = .error
////                    }).disposed(by: bag)
////
////
//                getBrands()!.observe(on: MainScheduler.instance).subscribe(onNext: { (brands) in
//                    self.brandsList = brands.smart_collections
//                    print(self.brandsList)
//
//                    if(self.brandsList!.isEmpty){
//                        self.state = .empty
//                    }else {
//                        self.state = .populated
//                    }
//                }, onError: { (error) in
//                  //  self.state = .error
//                    print(error.localizedDescription)
//                    }).disposed(by: bag)
//
//            }
        state = .loading
//        finalResult?.asDriver(onErrorJustReturn: []).drive(
//                    myCollectionView.rx.items(cellIdentifier: "cell", cellType: MyCollectionViewCell.self)){ index , element , cell in
//                            cell.countryStr = element.country
//                            cell.nameStr = element.name
//
//                }.disposed(by: disposeBag)
        
        let homeResponse = Observable.zip(getAds()!,getBrands()!).subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance).subscribe(onNext: {
            self.adsList = ($0).discount_codes

            self.brandsList = ($1).smart_collections
            print("ads :\($0.discount_codes.isEmpty)")
            print("brands :\($1.smart_collections.isEmpty)")

            if(self.adsList!.isEmpty && self.brandsList!.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }
            print(self.state)
        }, onError: { (error) in
            print(error.localizedDescription)
            //self.state = .error
        }).disposed(by: bag)

        
    }
    
}
