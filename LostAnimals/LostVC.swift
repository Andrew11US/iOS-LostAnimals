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
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    private var filteredAds: [Advertisment] = advertisments
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        if searchViewHeight.constant > 0 {
            self.animate(view: searchView, constraint: searchViewHeight, to: 0)
        } else {
            self.animate(view: searchView, constraint: searchViewHeight, to: 200)
            self.animate(view: filterView, constraint: filterViewHeight, to: 0)
        }
    }
    
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        if filterViewHeight.constant > 0 {
            self.animate(view: filterView, constraint: filterViewHeight, to: 0)
        } else {
            self.animate(view: filterView, constraint: filterViewHeight, to: 200)
            self.animate(view: searchView, constraint: searchViewHeight, to: 0)
        }
    }
    
    
}

// MARK: - UITableView Delegate
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.details.rawValue, sender: nil)
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

// MARK: - UISearchBar Delegate
extension LostVC: UISearchBarDelegate {
    // Dismiss keyboard on tap outside of searchBar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss keyboard when Search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // TODO: Do search!!!
    }
}
