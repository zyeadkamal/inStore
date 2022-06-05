//
//  ProductDetailsViewModel.swift
//  InStore
//
//  Created by mac on 6/4/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    
    var product: Product
    init(product: Product) {
        self.product = product
    }
}
