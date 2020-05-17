//
//  StorageManager.swift
//  Financial Assistant
//
//  Created by Andrew on 2/12/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Foundation

public struct StorageManager {
    
    static let shared = StorageManager()
    
    func pushObject(at: String, key: String, data: [String:AnyObject]) {
//        let dbRef = userReference.child(at).child(key)
//        dbRef.setValue(data)
    }
    
    func updateObject(at: String, key: String, data: [String:AnyObject]) {
//        let dbRef = userReference.child(at).child(key)
//        dbRef.updateChildValues(data)
    }
    
    func getTransactions(_ completion: @escaping () -> Void) {
        // Remove duplicates
//        transactions.removeAll()
        
//        userReference.child("transactions").observeSingleEvent(of: .value) { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshot {
//                    if let dict = snap.value as? Dictionary<String,AnyObject> {
//                        let id = snap.key
//                        let transaction = Transaction(id: id, data: dict)
//                        transactions.append(transaction)
//                    }
//                }
//            }
//            print("Transactions: ", transactions.count)
//            completion()
//        }
    }
    

    

    
    func deleteObject(location: String, id: String) {
//        userReference.child(location).child(id).removeValue { (error, ref) in
//            if error != nil {
//                print("Error occured while trying to delete an object with \(id)")
//                print(error.debugDescription)
//            } else {
//                print("value deleted for: ", id)
//            }
//        }
    }
    
    
    func retrieveData() {
//        userReference.child("transactions").observeSingleEvent(of: .value) { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshot {
//                    if let dict = snap.value as? Dictionary<String,AnyObject> {
//                        let id = snap.key
//                        print(Transaction(id: id, data: dict).convertToString ?? "zz")
//                    }
//                }
//            }
//        }
        
    }

    

    
    func createUser(uid: String) {
        
        let data : [String: String] = [
            "name" : "John Doe",
            "wallets" : "no wallets",
            "transactions" : "no transactions",
            "statistics" : "unavailable",
            "virtualWallets" : "no vWallets",
            "dateCreated" : Date().formattedString,
            "uid" : uid
        ]
        
//        StorageManager.dbReference.child(uid).updateChildValues(data)
    }
    
    // Cache user data to use offline in order to decrease number of calls to DB
    func setUserCache(uid: String, name: String = "John Doe") {
        let dict : [String: String] = [
            "name" : name,
            "latestLogin" : Date().formattedString,
            "uid" : uid,
            "UnifiedCurrencyCode": "USD"
        ]
        defaults.set(dict, forKey: "CurrentUser")
    }
    
    func updateUserCache(key: String, value: String) {
        let dict : [String: String] = [
            key : value
        ]
        defaults.set(dict, forKey: "CurrentUser")
    }
    
    func getUserCache() -> (name:String,uid:String,date:String,code:String) {
        var out : (name:String,uid:String,date:String,code:String) = ("name","uid","date","USD")
        
        if let dict = defaults.dictionary(forKey: "CurrentUser") {
            if let name = dict["name"] as? String {
                out.name = name
            }
            if let uid = dict["uid"] as? String {
                out.uid = uid
            }
            if let date = dict["latestLogin"] as? String {
                out.date = date
            }
            if let code = dict["UnifiedCurrencyCode"] as? String {
                out.code = code
            }
        }
        
        return out
    }
    
    func removeUserCache() {
        defaults.removeObject(forKey: "CurrentUser")
    }
    
}
