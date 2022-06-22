//
//  WishlistViewModel.swift
//  InStore
//
//  Created by Mohamed Ahmed on 05/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol WishlistViewModelType{
    var favourites : [Favourites]{get set}
    var favouritesObservable : Observable<[Favourites]>{get set}
    func fetchFavourites(customerEmail:String)
    func removeProductFromFavourites(customerEmail:String,deletedProductId: Int64)
    func getFavouriteByIndex(index:Int)-> Favourites
    func getFavouritesCount()-> Int
    func checkIfProductAddedToCart(customerEmail:String, productId :Int64)->Bool?
    func addToCart(product: Product,customerName:String)
    func deleteProductFromCart(deletedProductId: Int64,customerName:String)
}
class WishlistViewModel : WishlistViewModelType{
  
    var repo : RepositoryProtocol?
    var disboseBag = DisposeBag()
    var favourites: [Favourites] = []
    
    private var favouritesSubject : PublishSubject = PublishSubject<[Favourites]>()
    private var favouritesProducts: [Favourites] = []{
        didSet{
            self.favourites = favouritesProducts
            print(favouritesProducts.count)
            favouritesSubject.onNext(favouritesProducts)
        }
    }

    
    var favouritesObservable: Observable<[Favourites]>
    
    init(repo : RepositoryProtocol) {
        self.repo = repo
        favouritesObservable = favouritesSubject.asObserver()
    }
    
    
    func fetchFavourites(customerEmail:String) {
        repo?.fetchProductsFromFavourites(customerEmail: customerEmail)?.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance).subscribe(onNext: { [weak self] favouriteList in
                guard let self = self else {return}
            
                self.favouritesProducts = favouriteList
            }).disposed(by: self.disboseBag)
    }
    
    func removeProductFromFavourites(customerEmail: String, deletedProductId: Int64) {
        repo?.removeProductFromFavourites(customerEmail: customerEmail, deletedProductId: deletedProductId)

    }
    
    func getFavouriteByIndex(index:Int)-> Favourites{
        return favourites[index]
    }
    func getFavouritesCount()-> Int{
        return favourites.count
    }
    
    func addToCart(product: Product,customerName:String) {
        guard let repo = repo else {
            return
        }

        if(!repo.checkIfProductAddedToCart(customerEmail: customerName, productId: Int64(product.id))){
            repo.addToCart(product: product ,customerName: customerName)
        }        
    }

    
    func checkIfProductAddedToCart(customerEmail: String, productId: Int64) -> Bool? {
        return repo?.checkIfProductAddedToCart(customerEmail: customerEmail, productId: productId)
    }
    func deleteProductFromCart(deletedProductId: Int64,customerName:String){
        repo?.deleteProductFromCart(deletedProductId: deletedProductId , customerName: customerName)
    }
}
