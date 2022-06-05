//
//  HomeScreenViewModel.swift
//  InStore
//
//  Created by Mohamed Ahmed on 03/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

//new file for protocols
protocol HomeScreenViewModelType{
    func loadData()
    var ads : [DiscountCode]?{get}
    var brands : [Smart_collection]?{get}
    var showLoadingObservable: Observable<State> { get set }
    
    func getAdAtIndex(index: Int)->DiscountCode
    func getBrandAtIndex(indexPath:IndexPath)->Smart_collection
    func getAdsCount()->Int
    func getBrandsCount()-> Int
}

class HomeScreenViewModel : HomeScreenViewModelType{
    
    private var bag = DisposeBag()
    
    private var adsList : [DiscountCode]?{
        didSet {
            self.ads = adsList
        }
    }
    var ads : [DiscountCode]?
    
    
    private var brandsList : [Smart_collection]?{
        didSet {
            self.brands = brandsList
        }
    }
    var brands : [Smart_collection]?
    
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
    
    private func getAds()->Observable<DiscountCodes>?{
        let discount = repo.getDiscountCodes(priceRuleID: "1027348594860")
        return discount
    }
    private func getBrands() -> Observable<Smart_collections>?{
        let brands = repo.getBrands()
        return brands
    }
    
    
    func loadData() {
        state = .loading

        let homeResponse = Observable.zip(getAds()!,getBrands()!).subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance).subscribe(onNext: {
                [weak self] in
                guard let self = self else{return}
            
            self.adsList = ($0).discount_codes
            self.brandsList = ($1).smart_collections
           
                //            if(self.adsList!.isEmpty && self.brandsList!.isEmpty){

            if(self.brandsList!.isEmpty){
                self.state = .empty
            }else {
                self.state = .populated
            }
            print(self.state)
        }, onError: { (error) in
            //add error observable
            print(error.localizedDescription)
            //self.state = .error
        }).disposed(by: bag)

    }
    
    func getAdAtIndex(index: Int)->DiscountCode{
        return ads![index]
    }
    func getAdsCount()->Int{
        return ads?.count ?? 0
    }
    func getBrandAtIndex(indexPath:IndexPath)->Smart_collection{
        return brands![indexPath.row]
    }
    func getBrandsCount()-> Int{
        return brands?.count ?? 0
    }
    
    
    
}
