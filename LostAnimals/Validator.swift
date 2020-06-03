//
//  Validator.swift
//  Financial Assistant
//
//  Created by Andrew on 2/22/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//
import UIKit
import Foundation

// MARK: - Data validator
struct Validator {
    static let validate = Validator()
    
    func text(field: UITextField) -> String? {
        if let str = field.text?.trimmingCharacters(in: .whitespacesAndNewlines), !str.isEmpty {
            return str
        } else {
            print("Empty TF!")
            return nil
        }
    }
    
    func text(field: UITextView) -> String? {
        if let str = field.text?.trimmingCharacters(in: .whitespacesAndNewlines), !str.isEmpty {
            return str
        } else {
            print("Empty TV!")
            return nil
        }
    }
}
