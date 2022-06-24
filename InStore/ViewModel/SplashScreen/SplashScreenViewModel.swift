//
//  SplashScreenViewModel.swift
//  InStore
//
//  Created by Mohamed Ahmed on 04/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol SplashScreenViewModelType{
    var favouritesObservable : Observable<[Product]>{get set}
    func fetchFavourites(customerEmail:String)
}
class SplashScreenViewModel : SplashScreenViewModelType{
    
    private var repo : RepositoryProtocol?
    private var disboseBag = DisposeBag()
    var favouritesObservable : Observable<[Product]>
    private var favouritesSubject : PublishSubject = PublishSubject<[Product]>()
    private var favouriteList: [Product] = []{
        didSet{
            print(favouriteList.count)
            favouritesSubject.onNext(favouriteList)
        }
    }

    
    init(repo : RepositoryProtocol) {
        self.repo = repo
        favouritesObservable = favouritesSubject.asObserver()
    }
    
    func fetchFavourites(customerEmail: String) {
        repo?.fetchProductsFromFavourites(customerEmail: customerEmail)?.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance).subscribe(onNext: { [weak self] favouriteList in
                guard let self = self else {return}
                
                var favouriteListTemp :[Product] = []
                for favourite in favouriteList {
                    
                    let product = Product(id: Int(favourite.id), title: favourite.title! , description: favourite.description, vendor: favourite.vendor, productType: favourite.productType, images: [ProductImage(id: 0, productID: Int(favourite.id), position: 0, width: 0, height: 0, src: favourite.image!, graphQlID: "")], varients: [Varient(id: 0, productID: Int(favourite.id), title: favourite.title!, price: favourite.price!)], count: 0, isFavourite: true)
                    
                    favouriteListTemp.append(product)
                    
                    
                }
                self.favouriteList = favouriteListTemp
            }).disposed(by: self.disboseBag)
    }
    
    
    func getLocalProducts(customerName:String){
        repo?.fetchProductsFromCart(customerName: customerName)?.observe(on: MainScheduler.instance).subscribe(onNext: { productsList in
            Constants.cartProductsList = productsList
            }, onError: { error in
        }).disposed(by: DisposeBag())
    }
    
    
}
