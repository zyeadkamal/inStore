//
//  String+Extension.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation

extension String {
    
    func getNamedDayNamedMonthYear() -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // api iso format
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            return formatter.string(from: date)
        }
        return nil
    }
    
    func getDayMonthYear() -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // api iso format
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return nil
    }
    
    func contains(word : String) -> Bool
    {
        return self.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
    
}
