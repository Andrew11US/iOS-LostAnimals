//
//  CustomLabel.swift
//  LostAnimals
//
//  Created by Andrew on 6/3/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }

}
