//
//  NetworkWrapper.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Alamofire
import SwiftKeychainWrapper

struct NetworkWrapper {
    // MARK: - Test credentials
    //    "email" : "john.appleseed@example.com",
    //    "password" : "Qwerty4329",
    //    "username" : "jonny99"
    
    static func signIn(username: String, pass: String, completion: @escaping (Bool) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/auth/signin"
        let credentials: [String: String] = [
            "password" : pass,
            "username" : username
        ]
        
        AF.request(url, method: .post, parameters: credentials, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                if let dict = response.value as? [String: AnyObject] {
                    if let token = dict["accessToken"] as? String {
                        //                        print(token)
                        KeychainWrapper.standard.set(token, forKey: ACCESS_TOKEN)
                        print("Token saved: \(token)")
                    }
                }
                completion(true)
            case let .failure(error):
                print("Error signing in: \(error.localizedDescription)")
                completion(false)
            }
            //            print(response.value ?? "sign in response is empty")
        }
    }
    
    static func signUp(credentials: (email: String, pass: String, uName: String), completion: @escaping (Bool) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/auth/signup"
        let credentials: [String: String] = [
            "email" : credentials.email,
            "password" : credentials.pass,
            "username" : credentials.uName
        ]
        
        AF.request(url, method: .post, parameters: credentials, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                completion(true)
            case let .failure(error):
                print("Error signing up: \(error.localizedDescription)")
                completion(false)
            }
            print(response.value ?? "sign up response is empty")
        }
    }
    
    static func getAds(type: AdType, completion: @escaping (Bool) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/\(type.rawValue)"
        
        switch type {
        case .lost:
            lostAds.removeAll()
        case .found:
            foundAds.removeAll()
        case .adoption:
            adoptionAds.removeAll()
        }
        
        AF.request(url).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                
                if let data = response.value as? [String: AnyObject] {
                    if let ads = data["content"] as? [AnyObject] {
                        for ad in ads {
                            if let dict = ad as? [String: AnyObject] {
                                let id = dict["id"] as? Int ?? 0
                                let state = dict["state"] as? String ?? ""
                                let animalType = dict["type"] as? String ?? ""
                                let dateInt = dict["lostDate"] as? Int ?? 0
                                let date = Date(timeIntervalSince1970: TimeInterval(dateInt)).getShort
                                let town = dict["town"] as? String ?? ""
                                let district = dict["district"] as? String ?? ""
                                let street = dict["street"] as? String ?? ""
                                let imageUrl = dict["imageUrl"] as? String ?? ""
                                
                                print(dict)
                                let advertisment = Advertisment(id: id, state: state, adType: type.rawValue, animalType: animalType, animalName: "", date: date, town: town, district: district, street: street, phone: "", chipNumber: 0, description: "", imageUrl: imageUrl)
                                switch type {
                                case .lost:
                                    lostAds.append(advertisment)
                                case .found:
                                    foundAds.append(advertisment)
                                case .adoption:
                                    adoptionAds.append(advertisment)
                                }
                            }
                        }
                    }
                }
                
                completion(true)
            case let .failure(error):
                print("Error getting ads: \(error.localizedDescription)")
                completion(false)
            }
            //            print(response.value ?? "no data")
        }
    }
    
    static func getFilteredAds(type: AdType, filters: [String: String], completion: @escaping (Bool) -> Void) {
        var url = "https://aqueous-anchorage-15610.herokuapp.com/api/\(type.rawValue)?"
        
        for (key, value) in filters {
            url += "\(key)=\(value)"
        }
        
        switch type {
        case .lost:
            lostAds.removeAll()
        case .found:
            foundAds.removeAll()
        case .adoption:
            adoptionAds.removeAll()
        }
        
        AF.request(url).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                
                if let data = response.value as? [String: AnyObject] {
                    if let ads = data["content"] as? [AnyObject] {
                        for ad in ads {
                            if let dict = ad as? [String: AnyObject] {
                                let id = dict["id"] as? Int ?? 0
                                let state = dict["state"] as? String ?? ""
                                let animalType = dict["type"] as? String ?? ""
                                let dateInt = dict["lostDate"] as? Int ?? 0
                                let date = Date(timeIntervalSince1970: TimeInterval(dateInt)).getShort
                                let town = dict["town"] as? String ?? ""
                                let district = dict["district"] as? String ?? ""
                                let street = dict["street"] as? String ?? ""
                                let imageUrl = dict["imageUrl"] as? String ?? ""
                                
                                print(dict)
                                let advertisment = Advertisment(id: id, state: state, adType: type.rawValue, animalType: animalType, animalName: "", date: date, town: town, district: district, street: street, phone: "", chipNumber: 0, description: "", imageUrl: imageUrl)
                                switch type {
                                case .lost:
                                    lostAds.append(advertisment)
                                case .found:
                                    foundAds.append(advertisment)
                                case .adoption:
                                    adoptionAds.append(advertisment)
                                }
                            }
                        }
                    }
                }
                
                completion(true)
            case let .failure(error):
                print("Error getting ads: \(error.localizedDescription)")
                completion(false)
            }
            //            print(response.value ?? "no data")
        }
    }
    
    static func publishAd(type: String, data: [String: AnyObject], completion: @escaping (Bool) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/\(type)"
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: KeychainWrapper.standard.string(forKey: ACCESS_TOKEN) ?? "token"),
            .acceptEncoding("gzip, deflate, br"),
            .contentType("application/json"),
            .accept("application/json")
        ]
        
        AF.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: headers, interceptor: nil).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                completion(true)
            case let .failure(error):
                print("Error publishing ad: \(error.localizedDescription)")
                completion(false)
            }
            print(response.value ?? "no data")
        }
    }
    
    static func getImage(url: String, completion: @escaping (Data, Bool) -> Void) {
        AF.download(url).responseData { data in
            if let data = data.value {
                completion(data, true)
            }
            //            print(data.value ?? "")
        }
    }
    
    static func getImages(ads: [Advertisment], completion: @escaping () -> Void) {
        lostImagesDict.removeAll()
        for ad in ads {
            AF.download(ad.imageUrl).responseData { data in
                if let data = data.value {
                    lostImagesDict[ad.imageUrl] = UIImage(data: data) ?? UIImage(named: "test")!
                    completion()
                }
            }
        }
    }
    
}
