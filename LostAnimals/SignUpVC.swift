//
//  SignupVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var signUpBtn: CustomButton!
    
    let spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPassTextField.delegate = self
    }
    
    @IBAction func signUpBtnPressed(_ sender: AnyObject) {
        resignTextFields()
        guard let email = Validator.validate.text(field: emailTextField) else {
            self.showAlertWithTitle("Signing up error", message: "Email field cannot be empty")
            return
        }
        guard let username = Validator.validate.text(field: usernameTextField) else {
            self.showAlertWithTitle("Signing up error", message: "Username field cannot be empty")
            return
        }
        guard let password = Validator.validate.text(field: passwordTextField) else {
            self.showAlertWithTitle("Signing up error", message: "Password field cannot be empty")
            return
        }
        guard let confirmation = Validator.validate.text(field: confirmPassTextField) else {
            self.showAlertWithTitle("Signing up error", message: "Password confirmation field cannot be empty")
            return
        }
        
        if password == confirmation {
            let credentials = (email: email, pass: password, uName: username)
            addSpinner(spinner)
            NetworkWrapper.signUp(credentials: credentials) { success in
                if success {
                    KeychainWrapper.standard.set(username, forKey: KEY_UID)
                    self.performSegue(withIdentifier: Segue.signedUp.rawValue, sender: nil)
                } else {
                    self.showAlertWithTitle("Signing up error", message: "Unable to create an account for provided credentials")
                }
                self.removeSpinner(self.spinner)
            }
        } else {
            self.showAlertWithTitle("Signing up error", message: "Password does not match with confirmation")
        }
    }
    
    @IBAction func dismissBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextField Delegate methods
extension SignUpVC: UITextFieldDelegate {
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
        emailTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
    }
}
