//
//  ViewController+Extension.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

// MARK: - ViewController extensions
public extension UIViewController {
    
    func showAlertWithTitle(_ title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertVC.addAction(action)
        
        DispatchQueue.main.async { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    internal func addSpinner(_ spinner: Spinner) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    internal func removeSpinner(_ spinner: Spinner) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    internal func createNotification(name: Notification.Name) {
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    
    internal func animate(view: UIView, constraint: NSLayoutConstraint, to: Int) {
        constraint.constant = CGFloat(to)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            if to == 0 {
                view.superview?.subviews[0].isUserInteractionEnabled = true
            } else {
                view.superview?.subviews[0].isUserInteractionEnabled = false
            }
        }
    }
    
    // Monitors internet connection, if connection is not available - shows banner
    internal func monitorConnection(interval: TimeInterval, view: UIView, constraint: NSLayoutConstraint) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !Network.isConnected() {
                print("Connection is offline!")
                if constraint.constant != 60 {
                    self.animate(view: view, constraint: constraint, to: 60)
                }
            } else {
                if constraint.constant != 0 {
                    self.animate(view: view, constraint: constraint, to: 0)
                }
            }
        }
    }
    
//    internal func showBadInput(bad: Bool, view: UIView) {
//        if bad {
//            view.layer.borderWidth = 2.0
//            view.layer.borderColor = UIColor.appRed.cgColor
//        } else {
//            view.layer.borderWidth = 0
//            view.layer.borderColor = UIColor.clear.cgColor
//        }
//    }
}
