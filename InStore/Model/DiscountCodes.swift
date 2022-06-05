//
//  DiscountCodes.swift
//  InStore
//
//  Created by sandra on 6/4/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation



struct DiscountCodes:Codable{
    let discount_codes:[DiscountCode]
    
}
struct DiscountCode:Codable {
    var id:Int
    var price_rule_id:Int
    var code:String
    var usage_count:Double?
    var created_at:String?
    var updated_at:String?
}
