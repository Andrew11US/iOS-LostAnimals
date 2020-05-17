//
//  Date+Extension.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "eu_EU")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    var getYearAndMonth: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "us_US")
        formatter.dateFormat = "YYYY-MMM"
        return formatter.string(from: self)
    }
    
    var getShort: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "us_US")
        formatter.dateFormat = "dd MMM YYYY"
        return formatter.string(from: self)
    }
    
    var getYear: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "us_US")
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
    var getMonth: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "us_US")
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }
    
    var getDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
}
