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
//                                print(dict)
                                let ad = Advertisment(adType: type, dict: dict)

                                switch type {
                                case .lost:
                                    lostAds.append(ad)
                                case .found:
                                    foundAds.append(ad)
                                case .adoption:
                                    adoptionAds.append(ad)
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
        print(url)
        
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
                                
                                print(dict)
                                let ad = Advertisment(adType: type, dict: dict)
                                
                                switch type {
                                case .lost:
                                    lostAds.append(ad)
                                case .found:
                                    foundAds.append(ad)
                                case .adoption:
                                    adoptionAds.append(ad)
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
    
    static func getByID(type: AdType, id: Int, completion: @escaping (Bool, Advertisment?) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/\(type.rawValue)/\(id)"
        
        AF.request(url).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                
                if let dict = response.value as? [String: AnyObject] {
                    let ad = Advertisment(adType: type, dict: dict)
                    completion(true, ad)
                }
            case let .failure(error):
                print("Error getting ads: \(error.localizedDescription)")
                completion(false, nil)
            }
        }
    }
    
    static func publishAd(type: String, data: [String: AnyObject], completion: @escaping (Bool) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/\(type)"
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: KeychainWrapper.standard.string(forKey: ACCESS_TOKEN) ?? "token"),
            .acceptEncoding("gzip"),
            .contentType("application/json")
        ]
        
        AF.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers, interceptor: nil).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                completion(true)
            case let .failure(error):
                print("Error publishing ad: \(error.localizedDescription)")
                if error.responseCode == 401 || error.responseCode == 500 {
                    if let credentials = defaults.string(forKey: CREDENTIALS), let un = KeychainWrapper.standard.string(forKey: KEY_UID) {
                        signIn(username: un, pass: credentials) { _ in }
                    }
                }
                completion(false)
            }
            print(response.value ?? "no data")
        }
    }
    
    static func getImages(urls: [String], completion: @escaping (Data, Bool) -> Void) {
        for url in urls {
            AF.download(url).responseData { data in
                if let data = data.value {
                    completion(data, true)
                }
            }
        }
    }
    
    static func getImages(ads: [Advertisment], completion: @escaping () -> Void) {
        switch AdType(rawValue: ads[0].adType) {
        case .lost: lostImagesDict.removeAll()
        case .found: foundImagesDict.removeAll()
        case .adoption: adoptImagesDict.removeAll()
        default: return
        }
        
        for ad in ads {
            guard ad.imageURLs.count > 0 else {
                completion()
                return
            }
            print(ad.imageURLs[0])
            AF.download(ad.imageURLs[0]).responseData { data in
                if let data = data.value {
                    switch AdType(rawValue: ads[0].adType) {
                    case .lost: lostImagesDict[ad.imageURLs[0]] = UIImage(data: data) ?? UIImage(named: "logo")!
                    case .found: foundImagesDict[ad.imageURLs[0]] = UIImage(data: data) ?? UIImage(named: "logo")!
                    case .adoption: adoptImagesDict[ad.imageURLs[0]] = UIImage(data: data) ?? UIImage(named: "logo")!
                    default: return
                    }
                    completion()
                }
            }
        }
    }
    
}
