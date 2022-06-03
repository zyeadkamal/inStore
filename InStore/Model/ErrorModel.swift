//
//  ErrorModel.swift
//  InStore
//
//  Created by sandra on 6/2/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let errors: Errors?
}

// MARK: - Errors
struct Errors: Codable {
    let email, phone,addressesCountry,addressesZip,addressesCity,addressesTitle: [String]?
    
    enum CodingKeys: String, CodingKey {
        case email,phone
        case addressesCountry = "addresses.country"
        case addressesZip = "addresses.zip"
        case addressesCity = "addresses.city"
        case addressesTitle = "addresses.address1"
    }
    
//    let addresses:[AddressResponse]?
}
