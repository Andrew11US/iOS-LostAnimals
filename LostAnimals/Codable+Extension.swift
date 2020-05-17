//
//  Codable+Extension.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

// JSON Encoder encodes Class to JSON String
extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

// Transaction decodable
extension Decodable {
    var convertToObject: Advertisment? {
        let jsonDecoder = JSONDecoder()
        do {
            if let data = self as? Data {
                let object = try jsonDecoder.decode(Advertisment.self, from: data)
                return object
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
