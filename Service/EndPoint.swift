//
//  EndPoints.swift
//  rxNetworkLayer
//
//  Created by Mohamed Ahmed on 01/06/2022.
//

import Foundation

enum EndPoint : String {
    case customers = "customers" // login , register , myAccount(currency)
    case products = "products" // search , onBrandClick , onCategoryClick ,seeMorePopularProducts (wishlist)
    case brands = "smart_collections" // home
    case addresses = "addresses" // myAccount , selectAddress
    case orders = "orders" // myAccount , order
    case checkouts = "checkouts"
    case payments = "payments"
}
