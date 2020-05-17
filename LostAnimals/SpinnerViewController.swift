//
//  SpinnerViewController.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {

    var spinner = UIActivityIndicatorView(style: .medium)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
