//
//  Advertisment.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

struct Advertisment: Codable {
    var id: Int
    var state: String
    var adType: String
    var animalType: String
    var animalName: String
    var date: String
    var town: String
    var district: String
    var street: String
    var imageUrl: String
    var phone: String
    var email: String
    var title: String
    var chipNumber: String
    var distingMarks: String
    var description: String
    
//    init(id: Int, state: String, adType: String, animalType: String, animalName: String, date: String, town: String, district: String, street: String, phone: String, chipNumber: Int, description: String, imageUrl: String) {
//        self.id = id
//        self.state = adType
//        self.adType = adType
//        self.animalType = animalType
//        self.animalName = animalName
//        self.date = date
//        self.town = town
//        self.district = district
//        self.street = street
//        self.phone = phone
//        self.chipNumber = chipNumber
//        self.description = description
//        self.imageUrl = imageUrl
//    }
    

    

    
//    // MARK: - Initialize from DataSnapshot
    init(adType: AdType, dict: Dictionary<String, AnyObject>) {
        self.adType = adType.rawValue
        self.animalName = dict["name"] as? String ?? ""
        self.id = dict["id"] as? Int ?? 0
        self.state = dict["state"] as? String ?? ""
        self.animalType = dict["type"] as? String ?? ""
        let dateInt = dict["lostDate"] as? Int ?? 0
        self.date = Date(timeIntervalSince1970: TimeInterval(dateInt)).getShort
        self.town = dict["town"] as? String ?? ""
        self.district = dict["district"] as? String ?? ""
        self.street = dict["street"] as? String ?? ""
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        self.phone = dict["phoneNumber"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
        self.chipNumber = dict["chipNumber"] as? String ?? ""
        self.distingMarks = dict["distinguishingMarks"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
    }
//
//    // MARK: - Returns transaction like Dictionary<String, AnyObject>
//    func getDictionary() -> [String : AnyObject] {
//        return [
//            "id" : self.id,
//            "name" : self.name,
//            "type" : self.type,
//            "category" : self.category,
//            "currencyCode" : self.currencyCode,
//            "unifiedCurrencyCode" : self.unifiedCurrencyCode,
//            "originalAmount" : self.originalAmount,
//            "unifiedAmount" : self.unifiedAmount,
//            "dateCreated" : self.dateCreated,
//            "walletName" : walletName,
//            "walletID" : self.walletID,
//            ] as [String : AnyObject]
//    }
}
