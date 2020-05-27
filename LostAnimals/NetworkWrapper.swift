//
//  NetworkWrapper.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Alamofire

struct NetworkWrapper {
//    static func getRates(pair: (from:String,to:String), completion: @escaping (Double) -> Void) {
//        let url = "https://api.exchangerate-api.com/v4/latest/\(pair.from)"
//
//        AF.request(url).validate().responseJSON { response in
//            print(response.value ?? " ")
//            if let dict = response.value as? Dictionary<String, AnyObject> {
//                if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
//                    if let rate = rates[pair.to] as? Double {
//                        print("Rate: ", rate)
//                        completion(rate)
//                    }
//                } else {
//                    print("Unable to find currency pair.(to:)")
//                }
//            }
//        }
//
//    }
    
    static func getAds(with completion: @escaping ()->()) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com"
        
        AF.request(url).validate().responseJSON { response in
            print(response.value ?? "x")
            completion()
        }
    }
    
    static func signUp(credentials: (email: String, pass: String, uName: String), completion: @escaping (Bool) -> Void) {
        let url = "https://aqueous-anchorage-15610.herokuapp.com/api/auth/signup"
        let credentials: [String: String] = [
            "email" : credentials.email,
            "password" : credentials.pass,
            "username" : credentials.uName
        ]
        
//        let credentials: [String: String] = [
//            "email" : "john.appleseed@example.com",
//            "password" : "Qwerty4329",
//            "username" : "jonny99"
//        ]
        
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
    
}
