//
//  NetworkWrapper.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Alamofire

struct NetworkWrapper {
    static func getRates(pair: (from:String,to:String), completion: @escaping (Double) -> Void) {
        let url = "https://api.exchangerate-api.com/v4/latest/\(pair.from)"
        
        AF.request(url).validate().responseJSON { response in
            print(response.value ?? " ")
            if let dict = response.value as? Dictionary<String, AnyObject> {
                if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
                    if let rate = rates[pair.to] as? Double {
                        print("Rate: ", rate)
                        completion(rate)
                    }
                } else {
                    print("Unable to find currency pair.(to:)")
                }
            }
        }
        
    }
    
}
