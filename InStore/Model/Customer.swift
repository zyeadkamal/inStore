//
//  Customer.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

struct NewCustomer: Codable {
    var customer: Customer
}

struct LoginResponse: Codable {
    let customers: [Customer]
}
struct Customer: Codable {
    var first_name, email, tags: String?
    var id: Int?
    var addresses: [Address]?
    
}

struct Address: Codable {
    var id : Int?
    var customer_id : Int?
    var address1, city: String?
    var country: String?
    var phone : String?
}
