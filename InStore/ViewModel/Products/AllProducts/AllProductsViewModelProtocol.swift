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
    var filteredProduct: [Product]{get set}
    var cashAllProduct: [Product]{get set}
    var sortMechanism: SortMechanism?{get set}
    var priceRange: PriceRange?{get set}
    var womenCategory: Bool?{get set}
    var menCategory: Bool?{get set}
    var kidsCategory: Bool?{get set}
    var clothesCategory: Bool?{get set}
    var shoesCategory: Bool?{get set}
    var accessoriesCategory: Bool?{get set}
    var productCountObservable: Observable<Int?>{get set}
    func getAllProducts()
}
