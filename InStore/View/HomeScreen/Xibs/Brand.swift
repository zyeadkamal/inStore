//
//  Brand.swift
//  InStore
//
//  Created by Mohamed Ahmed on 26/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

struct Brand :Codable{
    let id:Int
    let name: String
    let image: BrandImage?
    
    enum CodingKeys : String , CodingKey {
        
        case id = "id"
        case name = "title"
        case image = "image"
        
    }
}
struct BrandImage :Codable {

    let src:String
    
    enum CodingKeys : String , CodingKey {
        case src = "src"
        
    }
}
