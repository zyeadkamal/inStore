//
//  DiscountCodes.swift
//  InStore
//
//  Created by Mohamed Ahmed on 03/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
struct DiscountCodes:Codable{
    let discount_codes:[DiscountCode]
    
}
struct DiscountCode:Codable {
    let id:Int
    let price_rule_id:Int
    let code:String
    let usage_count:Double?
    let created_at:String?
    let updated_at:String?
}
