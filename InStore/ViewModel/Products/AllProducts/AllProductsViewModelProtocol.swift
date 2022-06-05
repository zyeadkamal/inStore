//
//  AllProductsViewModelProtocol.swift
//  InStore
//
//  Created by mac on 6/3/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol AllProductsViewModelProtocol {
    var allProductsObservable: Observable<[Product]?>{get}
    var showLoadingObservable: Observable<State>{get}
    var allProducts: [Product]?{get set}
    func getAllProducts()
    func addToFavourite(product: Product , customerEmail: String)
    func removeProductFromFavourites(customerEmail:String,deletedProductId: Int64)
}
