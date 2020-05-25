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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterBase: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filterBaseHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelFilterBtn: UIButton!
    @IBOutlet weak var applyFilterBtn: UIButton!
    
    // MARK: - Variables
    private var filterView: FilterView!
    private var filteredAds: [Advertisment] = advertisments
    private var spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //TODO: - download ads
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        if searchViewHeight.constant > 0 {
            self.animate(view: searchView, constraint: searchViewHeight, to: 0)
            searchBar.resignFirstResponder()
        } else {
            self.animate(view: searchView, constraint: searchViewHeight, to: 60)
            self.animate(view: filterBase, constraint: filterBaseHeight, to: 0)
            searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        if filterBaseHeight.constant > 0 {
            self.animate(view: filterBase, constraint: filterBaseHeight, to: 0)
        } else {
            setupFilterView()
            self.animate(view: filterBase, constraint: filterBaseHeight, to: 400)
            self.animate(view: searchView, constraint: searchViewHeight, to: 0)
        }
        view.endEditing(true)
    }
    
    // MARK: - Filter actions
    @IBAction func cancelTapped(_ sender: CustomButton) {
        self.animate(view: filterBase, constraint: filterBaseHeight, to: 0)
    }
    
    @IBAction func applyTapped(_ sender: CustomButton) {
        self.animate(view: filterBase, constraint: filterBaseHeight, to: 0)
        // TODO: make filtering
    }
    
    // Filter setup
    private func setupFilterView() {
        filterView = FilterView()
        filterBase.addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: filterBase.topAnchor, constant: 0),
            filterView.bottomAnchor.constraint(equalTo: filterBase.bottomAnchor, constant: -60),
            filterView.trailingAnchor.constraint(equalTo: filterBase.trailingAnchor, constant: 0),
            filterView.leadingAnchor.constraint(equalTo: filterBase.leadingAnchor, constant: 0)
        ])
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertismentCell", for: indexPath) as? AdvertismentCell {
            
            let advertisment = advertisments[indexPath.row]
            cell.configureCell(ad: advertisment)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.lostDetails.rawValue, sender: advertisments[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC {
            if let ad = sender as? Advertisment {
                destination.ad = ad
            }
        }
    }
    
}

// MARK: - UISearchBar Delegate
extension LostVC: UISearchBarDelegate {
    // Dismiss keyboard when Search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // TODO: Do search!!!
    }
    
    // Cancel button tapped
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filteredAds = advertisments
        animate(view: searchView, constraint: searchViewHeight, to: 0)
    }
}

