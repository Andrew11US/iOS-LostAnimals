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
    var imageURLs: [String] = []
    var phone: String
    var email: String
    var title: String
    var chipNumber: String
    var distingMarks: String
    var description: String

    // MARK: - Initialize from DataSnapshot
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
        
        let imgURLs = dict["imageURLs"] as? [AnyObject] ?? []
        for urlDict in imgURLs {
            let url = urlDict["url"] as? String ?? ""
            self.imageURLs.append(url)
        }
        print(imageURLs)
    }
}
