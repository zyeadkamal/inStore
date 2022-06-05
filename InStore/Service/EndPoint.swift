//
//  EndPoint.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

enum EndPoint : String {
    case customers = "customers" // login , register , myAccount(currency)
    case products = "products" // search , onBrandClick , onCategoryClick ,seeMorePopularProducts (wishlist)
    case brands = "smart_collections" // home
    case addresses = "addresses" // myAccount , selectAddress, addAddress
    case orders = "orders" // myAccount , order
    case checkouts = "checkouts"
    case payments = "payments"
    case price_rules = "price_rules"
    case discount_codes = "discount_codes"
}
