//
//  Advertisment.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

struct Advertisment: Codable {
    var id: String
    var name: String
    var type: String
    var category: String
    var currencyCode: String
    var unifiedCurrencyCode: String
    var originalAmount: Double
    var unifiedAmount: Double
    var dateCreated: String
    var walletName: String
    var walletID: String
    
//    init(id: String, name: String, type: String, category: String, originalAmount: Double, unifiedAmount: Double, wallet: Wallet) {
//        self.id = id
//        self.name = name
//        self.type = type
//        self.category = category
//        self.currencyCode = wallet.currencyCode
//        self.unifiedCurrencyCode = defaults.string(forKey: "UnifiedCurrencyCode") ?? "USD"
//        self.originalAmount = originalAmount
//        self.unifiedAmount = unifiedAmount
//        self.unifiedCurrencyCode = wallet.unifiedCurrencyCode
//        self.dateCreated = Date().formattedString
//        self.walletName = wallet.name
//        self.walletID = wallet.id
//    }
//
//    // MARK: - Initialize from DataSnapshot
//    init(id: String, data: Dictionary<String, AnyObject>) {
//        self.id = id
//        self.name = data["name"] as? String ?? "name"
//        self.type = data["type"] as? String ?? "type"
//        self.category = data["category"] as? String ?? "category"
//        self.currencyCode = data["currencyCode"] as? String ?? "currencyCode"
//        self.unifiedCurrencyCode = data["unifiedCurrencyCode"] as? String ?? "unifiedCurrencyCode"
//        self.originalAmount = data["originalAmount"] as? Double ?? 0.0
//        self.unifiedAmount = data["unifiedAmount"] as? Double ?? 0.0
//        self.dateCreated = data["dateCreated"] as? String ?? "dateCreated"
//        self.walletName = data["walletName"] as? String ?? "_walletName"
//        self.walletID = data["walletID"] as? String ?? "walletID"
//    }
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
