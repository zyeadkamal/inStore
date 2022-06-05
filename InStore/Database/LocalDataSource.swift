//
//  LocalDataSource.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class LocalDataSource: LocalDataSourceProtocol {
    
    private static var local : LocalDataSourceProtocol?
    private var managedContext : NSManagedObjectContext?
    
    private init(managedContext : NSManagedObjectContext){
        self.managedContext = managedContext
    }
    
    public static func shared(managedContext : NSManagedObjectContext) -> LocalDataSourceProtocol?{
        if local == nil{
            local = LocalDataSource(managedContext: managedContext)
        }
        return local
    }
    func addToCart(product: Product) {
            let cartEntity = CartProduct(context: self.managedContext!)
            cartEntity.productId = Int64(product.id)
            cartEntity.productTitle = product.title
            cartEntity.productImg = product.images[0].src
            cartEntity.productPrice = product.varients?[0].price
            cartEntity.productAmount = 1
            cartEntity.customerEmail = "mando@ggg.com"
            cartEntity.vartiantId = Int64(product.varients?[0].id ?? 0)
            do{
                print("Product Saved Successfully")
                print(cartEntity)
                try managedContext?.save()
            }catch let error as NSError{
                print("\(error) in saving data to cart entity")
            }
        }
    

    
    func fetchProductsFromCart() -> Observable<[CartProduct]>? {
        return Observable<[CartProduct]>.create { (observer) -> Disposable in
                let currentUserEmail = "mando@ggg.com"
                    var cartElements = [CartProduct]()
                    let fetchReq = CartProduct.fetchRequest() as! NSFetchRequest
                    let emailPredicate = NSPredicate(format: "customerEmail == %@", currentUserEmail)
                    fetchReq.predicate = emailPredicate
                    do{
                        print("Products Fetched Successfully")
                        
            //            let allProductsInCart = try managedContext.fetch(fetchReq) as! [CartProduct]
            //            allProductsInCart.forEach { (product) in
            //                if product.customerEmail == currentUserEmail{
            //                    cartElements.append(product)
            //                }
            //            }
                        cartElements = try self.managedContext?.fetch(fetchReq) as! [CartProduct]
                        cartElements.forEach { (product) in
                            print("for product amount in local \(product.productAmount)")
                        }
                        print(cartElements.count)
                        observer.onNext(cartElements)
                    }catch let error as NSError{
                        print("\(error) in retreiving data from cart entity")
                        return Disposables.create {}
                    }
            return Disposables.create()
        }
    }
    
    func deleteProductFromCart(deletedProductId: Int64) {
        let retreivedProducts = fetchProductsFromCart()
        retreivedProducts?.subscribe(onNext: { products in
            products.forEach({ (product) in
                if product.value(forKey: "productId") as! Int64 == deletedProductId{
                    self.managedContext?.delete(product)
                }
            })
            do{
                try self.managedContext?.save()
            }catch let error as NSError{
                print("\(error) in deleting products from cart entity")
            }
            }).disposed(by: DisposeBag())
    }
    
    

    
    func editProductAmountInCart(productId : Int64, amount : Int16) {
        guard let allProductsInCart = fetchProductsFromCart() else {return}
        allProductsInCart.subscribe(onNext: { products in
            products.forEach { (product) in
                if product.value(forKey: "productId") as! Int64 == productId{
                    product.productAmount = amount
                    print("product amount local \(amount)")
                    do{
                        try self.managedContext?.save()
                    }catch let error as NSError{
                        print("\(error) in editing products in cart entity")
                    }
                }
            }
            }).disposed(by: DisposeBag())
    }
}
