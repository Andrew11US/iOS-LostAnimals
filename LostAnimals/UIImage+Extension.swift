//
//  UIImage+Extension.swift
//  LostAnimals
//
//  Created by Andrew on 5/31/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

// Converts UIImage to base64 representation
extension UIImage {
    func toBase64(format: ImageFormat) -> String? {
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
