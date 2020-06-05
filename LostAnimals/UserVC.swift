//
//  UserVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class UserVC: UIViewController {
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserData()
    }
    
    func getUserData() {
        if let username = defaults.string(forKey: USERNAME) {
            usernameLbl.text = username
        }
        if let email = defaults.string(forKey: EMAIL) {
            emailLbl.text = email
        }
    }
    
    @IBAction func signOut(_ sender: AnyObject) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        performSegue(withIdentifier: Segue.signedOut.rawValue, sender: nil)
    }
}
