//
//  FirstViewController.swift
//  LostAnimals
//
//  Created by Andrew on 5/4/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class LostVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }


}

// MARK: - UITableView delegate and data source
extension LostVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return advertisments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertismentCell", for: indexPath) as? AdvertismentCell {
            
            let advertisment = advertisments[indexPath.row]
            cell.configureCell(ad: advertisment)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
