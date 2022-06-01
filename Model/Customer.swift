//
//  Customer.swift
//  rxNetworkLayer
//
//  Created by Mohamed Ahmed on 01/06/2022.
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
    var customer_id : Int?
    var address1, city: String?
    var country: String?
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            print("error parsing")
            throw NSError()
        }
        return dictionary
    }
}
