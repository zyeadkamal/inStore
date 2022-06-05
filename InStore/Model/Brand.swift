//
//  Brand.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

struct Smart_collection :Codable{
    let id:Int
    let title: String
    let image: BrandImage?
    
}
struct BrandImage :Codable {

    let src:String
}

struct Smart_collections :Codable{
    let smart_collections : [Smart_collection]
}
