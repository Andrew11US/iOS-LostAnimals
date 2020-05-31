//
//  String+Extension.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

extension String {
    var createDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "eu_EU")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
    
    var dateFromShort: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "us_US")
        formatter.dateFormat = "dd MMM YYYY"
        return formatter.date(from: self)
    }
    
    var monthToDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "eu_EU")
        formatter.dateFormat = "MMM"
        return formatter.date(from: self)
    }
}

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    public func toBase64(format: ImageFormat) -> String? {
        var imageData: Data?

        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compression):
            imageData = self.jpegData(compressionQuality: compression)
        }

        return imageData?.base64EncodedString()
    }
}
