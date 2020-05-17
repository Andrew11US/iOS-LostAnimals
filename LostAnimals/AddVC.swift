//
//  AddVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import SPPermissions

class AddVC: UIViewController {

    // MARK: Variables
    private var permissions: [SPPermission] = [.camera, .photoLibrary, .locationWhenInUse]
    
    // ViewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - ViewDidAppear method
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in
            self.requestPermissions()
        }
    }
    

    // MARK: - Request mandatory authrizations method
    func requestPermissions() {
        var notAuthorized = false
        for permission in permissions {
            if !permission.isAuthorized {
                notAuthorized = true
            }
        }
        
        if notAuthorized {
            let controller = SPPermissions.dialog(permissions)
            controller.present(on: self)
        }
    }

}
