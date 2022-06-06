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
    
    var sortMechanism: SortMechanism?
    var priceRange: PriceRange?
    var womenCategory: Bool?
    var menCategory: Bool?
    var kidsCategory: Bool?
    var saleCategory: Bool?
    var vendorCategory: String?

    var clothesCategory: Bool?
    var shoesCategory: Bool?
    var accessoriesCategory: Bool?
    
    
    
    var productCountObservable: Observable<Int?>
    private var productCountSubject: PublishSubject<Int?> = PublishSubject()
    var allProductsObservable: Observable<[Product]?>
    private var allProductsSubject: PublishSubject<[Product]?> = PublishSubject()
    var filteredProduct = [Product]()
    var cashAllProduct = [Product]()
    var allProducts: [Product]?{
        didSet{
            productCountSubject.onNext(allProducts?.count)
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
    
    init(repository: RepositoryProtocol? , category:String? = nil) {
        self.repository = repository
        self.allProductsObservable = allProductsSubject.asObservable()
        showLoadingObservable = showLoadingSubject.asObserver()
        productCountObservable = productCountSubject.asObservable()
        specifyCategory(category:category)
    }
    
    private func specifyCategory(category:String?){
        guard let category = category else {return}
        
        switch category {
        case Categories.men.rawValue :
            self.menCategory = true
            
        case Categories.kid.rawValue :
            self.kidsCategory = true
            
        case Categories.women.rawValue :
            self.womenCategory = true
            
        case Categories.offers.rawValue :
            self.saleCategory = true
        
        default:
            self.vendorCategory = category
        }
        
    }
    func getAllProducts() {
        self.state = .loading
        repository?.getAllProducts()?
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (allProducts) in
                if allProducts.products.count == 0{
                    self?.state = .empty
                }else {
                    self?.state = .populated
                    self?.applyFilters(products: allProducts.products)
                    
                }
                }, onError: {[weak self] (error) in
                    self?.state = .error
            }).disposed(by: bag)
    }
    
    func addToFavourite(product: Product , customerEmail: String) {
        repository?.addToFavourite(product: product,customerEmail: customerEmail)
    }
    
    func removeProductFromFavourites(customerEmail: String, deletedProductId: Int64) {
        repository?.removeProductFromFavourites(customerEmail: customerEmail, deletedProductId: deletedProductId)
    }
    
    
    
    private func applyFilters( products: [Product]) {
        
        var productList = Set<Product>()
        
        if let vendorCategory = vendorCategory {
            for product in products {
                if let vendor = product.vendor {
                    if vendor.contains(word: vendorCategory){
                        productList.insert(product)
                    }
                }
            }
        }
    
        
        
        if womenCategory != nil {
            for product in products{
                if let tag = product.tag{
                    if tag.contains(word: Categories.women.rawValue){
                        productList.insert(product)
                    }
                }
            }
        }
        
        
        if menCategory != nil {
            for product in products{
                if let tag = product.tag{
                    if tag.contains(word: Categories.men.rawValue){
                        productList.insert(product)
                    }
                }
            }
        }
        
        
        
        if kidsCategory != nil {
            for product in products{
                if let tag = product.tag{
                    if tag.contains(word: Categories.kid.rawValue){
                        productList.insert(product)
                    }
                }
            }
        }
        
        if saleCategory != nil {
            for product in products{
                if let tag = product.tag{
                    if tag.contains(word: Categories.offers.rawValue){
                        productList.insert(product)
                    }
                }
            }
        }
        
        
        
        
        if shoesCategory != nil {
            for product in products{
                if let productType = product.productType{
                    if productType.contains(word: "SHOES"){
                        productList.insert(product)
                    }
                }
            }
        }
        
        
        
        if accessoriesCategory != nil {
            for product in products{
                if let productType = product.productType{
                    if productType.contains(word: "ACCESSORIES"){
                        productList.insert(product)
                    }
                }
            }
        }
        
        
        
        if clothesCategory != nil {
            for product in products{
                if let productType = product.productType{
                    if productType.contains(word: "CLOTHES"){
                        productList.insert(product)
                    }
                }
            }
        }
        
        var productArr = [Product]()
        if productList.count != 0 {
            for product in productList{
                productArr.append(product)
            }
        }else {
            productArr = products
        }
        
        var finalList = [Product]()

        if let priceRange = priceRange {
            switch priceRange {
            case .Under25:
                for product in productArr {
                    if (Double(product.varients?[0].price ?? "20")!) < 25.0  {
                        finalList.append(product)
                    }
                }
            case .From25To50:
                for product in productArr {
                    if (Double(product.varients?[0].price ?? "40")!) >= 25.0 && (Double(product.varients?[0].price ?? "40")!) < 50.0 {
                        finalList.append(product)
                    }
                }
            case .From50To100:
                for product in productArr {
                    if (Double(product.varients?[0].price ?? "20")!) >= 50.0 && (Double(product.varients?[0].price ?? "40")!) < 100.0  {
                        finalList.append(product)
                    }
                }
            case .From100To200:
                for product in productArr {
                    if (Double(product.varients?[0].price ?? "20")!) >= 100.0 && (Double(product.varients?[0].price ?? "40")!) < 200.0  {
                        finalList.append(product)
                    }
                }
            case .From200AndAbove:
                for product in productArr {
                    if (Double(product.varients?[0].price ?? "20")!) >= 200.0  {
                        finalList.append(product)
                    }
                }
            }
        }else {
            finalList = productArr
        }

        if let sortMechanism = sortMechanism {
            switch sortMechanism {
            case .HighToLow:
                finalList.sort(by: {$0 > $1})
            case .LowToHigh:
                finalList.sort(by: {$0 < $1})
            }
        }


        allProducts = finalList
        cashAllProduct = finalList
        
    }
    
    
}
