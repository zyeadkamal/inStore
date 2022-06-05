//
//  Product.swift
//  InStore
//
//  Created by sandra on 6/2/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

struct AllProducts:Codable{
    var products:[Product]
    enum CodingKeys : String , CodingKey {
        case products = "products"
    }
}
struct Product:Codable, Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    var id:Int
    var title:String
    var description:String
    var vendor:String?
    var productType:String?
    var images:[ProductImage]
    var options:[OptionList]?
    var varients:[Varient]?
    var count: Int = 0
    var isFavourite: Bool = false
    
    enum CodingKeys : String , CodingKey {
            case id = "id"
            case title = "title"
            case description = "body_html"
            case vendor = "vendor"
            case productType = "product_type"
            case images = "images"
            case options = "options"
            case varients = "variants"

        }
      
}
struct ProductImage:Codable {
    var id:Int
    var productID:Int
    var position:Int
    var width:Double
    var height:Double
    var src:String
    var graphQlID:String
    
   enum CodingKeys : String , CodingKey {
          
          case id = "id"
          case productID = "product_id"
          case position = "position"
          case width = "width"
          case height = "height"
          case src = "src"
          case graphQlID = "admin_graphql_api_id"

      }
    
}
struct OptionList:Codable{
    
    var id:Int
    var productID :Int
    var name:String
    var position:Int
    var values:[String]?
    
    enum CodingKeys : String , CodingKey {
          
          case id = "id"
          case productID = "product_id"
          case name = "name"
          case position = "position"
          case values = "values"
          
      }
    
}
struct Varient:Codable {
    var id:Int
    var productID:Int
    var title:String
    var price :String
    
    enum CodingKeys : String , CodingKey {
            
            case id = "id"
            case productID = "product_id"
            case title = "title"
            case price = "price"
            
        }
}
