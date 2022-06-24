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
    func addToCart(product: Product , customerName:String) {
        let cartEntity = CartProduct(context: self.managedContext!)
        cartEntity.productId = Int64(product.id)
        cartEntity.productTitle = product.title
        cartEntity.productImg = product.images[0].src
        cartEntity.productPrice = product.varients?[0].price
        cartEntity.productAmount = 1
        cartEntity.customerEmail = customerName
        cartEntity.vartiantId = Int64(product.varients?[0].id ?? 0)
        do{
            print("Product Saved Successfully")
            print(cartEntity)
            try managedContext?.save()
        }catch let error as NSError{
            print("\(error) in saving data to cart entity")
        }
    }
    
    
    func checkIfProductAddedToCart(customerEmail:String, productId :Int64)->Bool?{
        var isAdded : Bool = false
        let retreivedProducts = fetchProductsFromCart(customerName:  customerEmail)

        retreivedProducts?.subscribe(onNext: { products in
            products.forEach({ (product) in
                if product.value(forKey: "productId") as! Int64 == productId{
                    isAdded = true
                }
            })
            do{
                try self.managedContext?.save()
            }catch let error as NSError{
                print("\(error) in deleting products from cart entity")
            }
        }).disposed(by: DisposeBag())
        return isAdded
    }
    
    func fetchProductsFromCart(customerName:String) -> Observable<[CartProduct]>? {
        return Observable<[CartProduct]>.create { (observer) -> Disposable in
            let currentUserEmail = customerName
            var cartElements = [CartProduct]()
            let fetchReq = CartProduct.fetchRequest() as! NSFetchRequest
            let emailPredicate = NSPredicate(format: "customerEmail == %@", currentUserEmail)
            fetchReq.predicate = emailPredicate
            do{
                print("Cart Products Fetched Successfully")
                cartElements = try self.managedContext?.fetch(fetchReq) as! [CartProduct]
                cartElements.forEach { (product) in
                    print("for product amount in local \(product.productId) \(product.productTitle) \(product.productAmount)")
                }
                print(" count in fetch \(cartElements.count)")
                observer.onNext(cartElements)
            }catch let error as NSError{
                print("\(error) in retreiving data from cart entity")
                return Disposables.create {}
            }
            return Disposables.create()
        }
    }
    
    func deleteProductFromCart(deletedProductId: Int64 , customerName:String) {
        let retreivedProducts = fetchProductsFromCart(customerName: customerName)
        retreivedProducts?.subscribe(onNext: { products in
            products.forEach({ (product) in
                if product.value(forKey: "productId") as! Int64 == deletedProductId{
                    print("\(product.productTitle) deleted \(product.productAmount)")
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
    
    
    
    
    func editProductAmountInCart(productId : Int64, amount : Int16,customerName:String) {
        guard let allProductsInCart = fetchProductsFromCart(customerName: customerName) else {return}
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
    
    func deleteAllFromCart(customerEmail: String){
        guard let allProducts = fetchProductsFromCart(customerName: customerEmail) else {return}
        allProducts.subscribe(onNext: { (products) in
            products.forEach { (product) in
                self.managedContext?.delete(product)
            }
            do{
                try self.managedContext?.save()
            }catch let error as NSError{
                print("\(error) in deleting products from cart entity")
            }
        }).disposed(by: DisposeBag())
    }
    
    func addToFavourite(product: Product , customerEmail: String) {
        let favouritesEntity = Favourites(context: self.managedContext!)
        favouritesEntity.id = Int64(product.id)
        favouritesEntity.title = product.title
        favouritesEntity.image = product.images[0].src
        favouritesEntity.price = product.varients?[0].price
        favouritesEntity.descreption = product.description
        favouritesEntity.vendor = product.vendor
        favouritesEntity.productType = product.productType
        favouritesEntity.customerEmail = customerEmail

        
        do{
            print("Product Added To Favourites Successfully")
            print(favouritesEntity)
            try managedContext?.save()
        }catch let error as NSError{
            print("\(error) in saving data to favourite entity")
        }
    }
    
    func fetchProductsFromFavourites(customerEmail:String) -> Observable<[Favourites]>? {
        return Observable<[Favourites]>.create { (observer) -> Disposable in
            let currentUserEmail = customerEmail

//            let currentUserEmail = "mando@ggg.com"
            var favourites = [Favourites]()
            let fetchReq = Favourites.fetchRequest() as! NSFetchRequest
            let emailPredicate = NSPredicate(format: "customerEmail == %@", currentUserEmail)
            fetchReq.predicate = emailPredicate
            do{
                print("Products Fetched Successfully")

                favourites = try self.managedContext?.fetch(fetchReq) as! [Favourites]
                print(favourites.count)
                observer.onNext(favourites)
        
            }catch let error as NSError{
                print("\(error) in retreiving data from favourites entity")
                return Disposables.create {}
            }
            return Disposables.create()
        }
    }
    func removeProductFromFavourites(customerEmail:String,deletedProductId: Int64) {
        let retreivedProducts = fetchProductsFromFavourites(customerEmail: customerEmail)
        retreivedProducts?.subscribe(onNext: { products in
            products.forEach({ (product) in
                if product.value(forKey: "id") as! Int64 == deletedProductId{
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
    
}
