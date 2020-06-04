//
//  LoginVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: CustomButton!
    
    let spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Deletes KEY for auto login if uncommented
//        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        // Auto Login if ID is found in Keychain
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            print("Key has been found in keychain!")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segue.signedIn.rawValue, sender: nil)
            }
        }
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func signInBtnPressed(_ sender: AnyObject) {
        resignTextFields()
        guard let username = Validator.validate.text(field: usernameTextField) else {
            self.showAlertWithTitle("Signing in error", message: "Username field cannot be empty")
            return
        }
        guard let password = Validator.validate.text(field: passwordTextField) else {
            self.showAlertWithTitle("Signing in error", message: "Password field cannot be empty")
            return
        }
        
        addSpinner(spinner)
        NetworkWrapper.signIn(username: username, pass: password) { success in
            if success {
                KeychainWrapper.standard.set(username, forKey: KEY_UID)
                defaults.set(password, forKey: CREDENTIALS)
                self.performSegue(withIdentifier: Segue.signedIn.rawValue, sender: nil)
            } else {
                self.showAlertWithTitle("Signing in error", message: "Unable to sign in with provided credentials")
            }
            self.removeSpinner(self.spinner)
        }
    }
    
}

// MARK: - TextField Delegate methods
extension SignInVC: UITextFieldDelegate {
    // Dismiss keyboard function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss when return btn pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignTextFields()
        return true
    }
    
    func resignTextFields() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
