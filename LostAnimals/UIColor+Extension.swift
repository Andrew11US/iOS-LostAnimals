//
//  UIColor+Extension.swift
//  LostAnimals
//
//  Created by Andrew on 6/3/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

extension UIColor {
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    static var appGreen: UIColor {
        return UIColor(hexString: "#037C78")
    }
    
    static var appPurple: UIColor {
        return UIColor(hexString: "#8D74D6")
    }
    
    static var badgeRed: UIColor {
        return UIColor(hexString: "#ED4C3F")
    }
    
    static var badgeGreen: UIColor {
        return UIColor(hexString: "#56BF89")
    }
    
    static var badgeYellow: UIColor {
        return UIColor(hexString: "#F7B500")
    }
    
    
}
