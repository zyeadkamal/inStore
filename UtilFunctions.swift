//
//  UtilFunctions.swift
//  
//
//  Created by mac on 6/22/22.
//

import Foundation

class Utils{
    static func isNotLoggedIn() -> Bool  {
        return (MyUserDefaults.getValue(forKey: .loggedIn) == nil)
    }
}


