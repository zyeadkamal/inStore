//
//  UtilFunctions.swift
//  
//
//  Created by mac on 6/22/22.
//

import Foundation

class Utils{
    static func isNotLoggedIn() -> Bool  {
        if(MyUserDefaults.getValue(forKey: .loggedIn) == nil){
            return true
        }else if(MyUserDefaults.getValue(forKey: .loggedIn) as! Int == 0) {
            return true
        }else{
            return false
        }
    }
    
    static func getUserId() -> Int {
           if (MyUserDefaults.getValue(forKey: .id)) == nil{
               return 0
           }
           return (MyUserDefaults.getValue(forKey: .id) as! Int)
       }
}


