//
//  MockOrder.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

struct Orders: Codable {
    var orders : [MockOrder]
}

struct OrderItem: Codable {
    var variant_id, quantity: Int?
    var name: String! = ""
    var price: String!
}

struct OrderCustomer: Codable {
    var id: Int
    var first_name :String?
    
}

struct MockOrder: Codable {
    var line_items: [OrderItem]
    let customer: OrderCustomer
    var financial_status: String = "paid"
    var created_at :String?
    var id : Int?
    var currency:String?
    var current_total_price:String?
}
