//
//  UserDefaults.swift
//  InStore
//
//  Created by Mohamed Ahmed on 04/06/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

enum Keys:String {
    case isFirstTime = "isFirstTime"
    case loggedIn = "loggedIn"
    case username = "username"
    case email = "email"
    case id = "id"
    case hasAddress = "hasAddress"
    case currency = "currency"
}

class MyUserDefaults {
    private static var shared = UserDefaults.standard
    
    private init(){
        
    }
    public static func add<T>(val : T,key : Keys){
        shared.setValue(val, forKey: key.rawValue)
    }
    
    public static func getValue(forKey key: Keys) -> Any?{
        return shared.value(forKey: key.rawValue) ?? nil
    }
}
