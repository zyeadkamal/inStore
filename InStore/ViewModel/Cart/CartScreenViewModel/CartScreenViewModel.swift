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
    func addProductToCart(product : Product) 
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
    private var cartSubject : PublishSubject = PublishSubject<[CartProduct]>()
    private var cartProducts: [CartProduct] = []{
        didSet{
            self.products = cartProducts
            print(products.count)
            cartSubject.onNext(cartProducts)
        }
    }
    
    
    init(repo : RepositoryProtocol) {
        self.repo = repo
        cartObservable = cartSubject.asObserver()
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
        fetchAllSavedProducts()?.observe(on: MainScheduler.instance).subscribe(onNext: { productsList in
            self.cartProducts = productsList
            }).disposed(by: DisposeBag())
    }
    
    func getListOfProductsToOrder() -> [PostLineItem]{ //[CartProduct]
        var myOrder = [PostLineItem]()
//        fetchAllSavedProducts()?.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { order in
//            order.forEach { (product) in
//                myOrder.append(PostLineItem(variantID: Int(product.vartiantId), quantity: Int(product.productAmount)))
//                print("my order -> \(myOrder)")
//            }
//            }).disposed(by: DisposeBag())
        self.products.forEach { (product) in
            myOrder.append(PostLineItem(variantID: Int(product.vartiantId), quantity: Int(product.productAmount)))
            print("my order -> \(myOrder)")
        }
        return myOrder
    }
    
}
