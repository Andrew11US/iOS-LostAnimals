//
//  NetworkWrapper.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Alamofire

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
                completion(true)
            case let .failure(error):
                print("Error signing in: \(error.localizedDescription)")
                completion(false)
            }
            print(response.value ?? "sign in response is empty")
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
        
        AF.request(url).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success:
                print("success")
                completion(true)
            case let .failure(error):
                print("Error getting ads: \(error.localizedDescription)")
                completion(false)
            }
            print(response.value ?? "no data")
        }
    }
    
    // TODO: - refactor to use access token
    static func publishAd(type: String, data: [String: String], completion: @escaping (Bool) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/\(type)"
        
        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseJSON { response in
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
//        AF.request(url).validate().responseData { (data) in
//            if let data = data.data {
//                completion(data, true)
//            }
//            print(data.result)
//        }
        AF.download(url).responseData { (response) in
            if let data = response.value {
                completion(data, true)
            }
            print(response.value ?? "")
        }
    }
    
}
