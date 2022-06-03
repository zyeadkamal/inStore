//
//  LocalDataSource.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import CoreData

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
        cartEntity.productId = Int32(product.id)
        cartEntity.productTitle = product.title
        cartEntity.productImg = product.images[0].src
        cartEntity.productPrice = product.varients?[0].price
        cartEntity.productAmount = 1
        cartEntity.customerEmail = "mando@ggg.com"
        do{
            print("Product Saved Successfully")
            try managedContext?.save()
        }catch let error as NSError{
            print("\(error) in saving data to cart entity")
        }
    }
    
    func fetchProductsFromCart() -> [CartProduct]? {
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
            cartElements = try managedContext?.fetch(fetchReq) as! [CartProduct]
            return cartElements
        }catch let error as NSError{
            print("\(error) in retreiving data from cart entity")
            return nil
        }
    }
    
    func deleteProductFromCart(deletedProductId: Int32) {
        let retreivedProducts = fetchProductsFromCart()
        retreivedProducts?.forEach({ (product) in
            if product.value(forKey: "productId") as! Int32 == deletedProductId{
                managedContext?.delete(product)
            }
        })
        do{
            try managedContext?.save()
        }catch let error as NSError{
            print("\(error) in deleting products from cart entity")
        }
    }
    
    func editProductAmountInCart(productId : Int32, amount : Int16) {
        guard let allProductsInCart = fetchProductsFromCart() else {return}
        allProductsInCart.forEach { (product) in
            if product.value(forKey: "productId") as! Int16 == productId{
                product.productAmount = amount
                do{
                    try managedContext?.save()
                }catch let error as NSError{
                    print("\(error) in editing products in cart entity")
                }
            }
        }
    }
}
