//
//  Brand.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

struct Brand :Codable{
    let id:Int
    let name: String
    let image: BrandImage?
    
}
struct BrandImage :Codable {

    let src:String
}
