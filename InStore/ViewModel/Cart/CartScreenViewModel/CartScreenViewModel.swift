//
//  CartScreenViewModel.swift
//  InStore
//
//  Created by sandra on 6/3/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol CartViewModelType {
    var products : [CartProduct]{get set}
    var cartObservable : Observable<[CartProduct]>{get set}
    var showLoadingObservable : Observable<State>{get set}
    func updateProductAmount(productId : Int64, amount: Int16)
    func fetchAllSavedProducts() -> Observable<[CartProduct]>?
    func deleteProduct(productId : Int64)
    func getLocalProducts()
    func getListOfProductsToOrder() -> [PostLineItem]
}


class CartViewModel: CartViewModelType {
    
    var repo : RepositoryProtocol?
    
    var products : [CartProduct] = [CartProduct]()
    var cartObservable : Observable<[CartProduct]>
    private var cartSubject : BehaviorSubject = BehaviorSubject<[CartProduct]>.init(value: [])
    private var cartProducts: [CartProduct] = []{
        didSet{
            self.products = cartProducts
            print(products.count)
            cartSubject.onNext(cartProducts)
        }
    }
    
    
    var showLoadingObservable: Observable<State>
    private let showLoadingSubject : BehaviorSubject = BehaviorSubject<State>.init(value: .empty)
    
    var state : State = .empty{
        didSet{
            showLoadingSubject.onNext(state)
        }
    }
    
    
    init(repo : RepositoryProtocol) {
        self.repo = repo
        cartObservable = cartSubject.asObserver()
        showLoadingObservable = showLoadingSubject.asObservable()
    }
    
    func addProductToCart(product : Product) {
        repo?.addToCart(product: product)
    }
    
    func updateProductAmount(productId : Int64, amount: Int16) {
        repo?.editProductAmountInCart(productId: productId, amount: amount)
    }
    
    internal func fetchAllSavedProducts() -> Observable<[CartProduct]>? {
        return repo?.fetchProductsFromCart()
    }
    
    func deleteProduct(productId : Int64){
        repo?.deleteProductFromCart(deletedProductId: productId)
    }
    
    func getLocalProducts(){
        state = .loading
        fetchAllSavedProducts()?.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] productsList in
            guard let self = self else {return}
            self.cartProducts = productsList
            if(self.cartProducts.isEmpty){
                self.state = .empty
            }else{
                self.state = .populated
            }
            }, onError: { error in
                self.state = .error
        }).disposed(by: DisposeBag())
    }
    
    func getListOfProductsToOrder() -> [PostLineItem]{ //[CartProduct]
        var myOrder = [PostLineItem]()
        self.products.forEach { (product) in
            myOrder.append(PostLineItem(variantID: Int(product.vartiantId), quantity: Int(product.productAmount)))
            print("my order -> \(myOrder)")
        }
        return myOrder
    }
    
}
