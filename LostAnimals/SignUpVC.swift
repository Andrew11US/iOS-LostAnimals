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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var signUpBtn: CustomButton!
    
    let spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPassTextField.delegate = self
    }
    
    @IBAction func signUpBtnPressed(_ sender: AnyObject) {
        resignTextFields()
        guard let email = emailTextField.text else { return }
        guard let username = emailTextField.text else { return } // <<<
        guard let password = passwordTextField.text else { return }
        guard let confirmation = confirmPassTextField.text else { return }
        
        if password == confirmation {
            let credentials = (email: email, pass: password, uName: username)
            addSpinner(spinner)
            NetworkWrapper.signUp(credentials: credentials) {
                // TODO: - check if success
                self.removeSpinner(self.spinner)
                self.performSegue(withIdentifier: Segue.signedUp.rawValue, sender: nil)
            }
            
            
//            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                if let err = error {
//                    print(err.localizedDescription)
//                    self.removeSpinner(self.spinner)
//                } else {
//                    guard let user = user?.user else { return }
//                    print("New user has been succesfully created: ", user.uid)
//                    StorageManager.shared.createUser(uid: user.uid)
//                    KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
//                    StorageManager.shared.setUserCache(uid: user.uid)
//                    self.removeSpinner(self.spinner)
//                    self.performSegue(withIdentifier: Segue.signedUp.rawValue, sender: nil)
//                }
//            }
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
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
        return true
    }
    
    func resignTextFields() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
    }
}
