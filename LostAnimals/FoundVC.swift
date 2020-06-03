//
//  SecondViewController.swift
//  LostAnimals
//
//  Created by Andrew on 5/4/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class FoundVC: UIViewController {
    
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
    private var filteredAds: [Advertisment] = foundAds
    private var spinner = Spinner()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setRefreshControl()
        
        addSpinner(spinner)
        NetworkWrapper.getAds(type: .found) { success in
            if success {
                self.filteredAds = foundAds
                print(foundAds.count)
                NetworkWrapper.getImages(ads: foundAds) {
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            } else {
                self.showAlertWithTitle("Error loading data", message: "Something went wrong, data could not be downloaded")
            }
            self.removeSpinner(self.spinner)
        }
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
        var filtersDict: [String: String] = [:]
        
        let animalType = filterView.selectedAnimalType.trimmingCharacters(in: .whitespaces).lowercased()
        if !animalType.isEmpty {
            filtersDict["type"] = animalType
        }
        
        if Validator.validate.text(field: filterView.dateTextField) != nil {
            filtersDict["dateAfter"] = "\(Int(filterView.dates.from.timeIntervalSince1970))"
            if let to = filterView.dates.to {
                filtersDict["&dateBefore"] = "\(Int(to.timeIntervalSince1970))"
            } else {
                filtersDict["&dateBefore"] = "\(Int(Date().timeIntervalSince1970))"
            }
            print(filtersDict)
        }
        
        if let town = Validator.validate.text(field: filterView.cityTextField) {
            var temp = ""
            for item in town.split(separator: " ") {
                temp += item + "%20"
            }
            filtersDict["town"] = temp
        }
        if let district = Validator.validate.text(field: filterView.regionTextField) {
            var temp = ""
            for item in district.split(separator: " ") {
                temp += item + "%20"
            }
            filtersDict["district"] = temp
        }
        if let chip = Validator.validate.text(field: filterView.chipTextField) {
            filtersDict["chip"] = chip // check chip type
        }
        
        if !filtersDict.isEmpty {
            NetworkWrapper.getFilteredAds(type: .found, filters: filtersDict) { (success) in
                if success {
                    self.filteredAds = foundAds
                    print(foundAds.count)
                    NetworkWrapper.getImages(ads: foundAds) {
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
    
    private func setRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        NetworkWrapper.getAds(type: .found) { success in
            if success {
                self.filteredAds = foundAds
                print(foundAds.count)
                self.refreshControl.endRefreshing()
                NetworkWrapper.getImages(ads: foundAds) {
                    self.tableView.reloadData()
                }
            } else {
                self.showAlertWithTitle("Error loading data", message: "Something went wrong, data could not be downloaded")
            }
        }
    }
}

// MARK: - UITableView delegate and data source
extension FoundVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertismentCell", for: indexPath) as? AdvertismentCell {
            
            let ad = filteredAds[indexPath.row]
            var image = UIImage(named: "logo")!
            if foundImagesDict.count > 0 {
                image = foundImagesDict[ad.imageURLs[0]] ?? UIImage(named: "logo")!
            }
            cell.configureCell(ad: ad, image: image)
            return cell
        } else {
            return AdvertismentCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.foundDetails.rawValue, sender: filteredAds[indexPath.row])
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
extension FoundVC: UISearchBarDelegate {
    // Dismiss keyboard when Search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filteredAds.removeAll()
        for ad in foundAds {
            if let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces).capitalized, !searchText.isEmpty {
                if ad.district.hasPrefix(searchText) {
                    filteredAds.append(ad)
                } else if ad.town.hasPrefix(searchText) {
                    filteredAds.append(ad)
                }
            }
        }
        tableView.reloadData()
    }
    
    // Cancel button tapped
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filteredAds = foundAds
        tableView.reloadData()
        animate(view: searchView, constraint: searchViewHeight, to: 0)
    }
}
