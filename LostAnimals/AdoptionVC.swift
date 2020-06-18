//
//  AdoptionVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class AdoptionVC: UIViewController {

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
    private var filteredAds: [Advertisment] = adoptionAds
    private var spinner = Spinner()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setRefreshControl()
        
        addSpinner(spinner)
        NetworkWrapper.getAds(type: .adoption) { success in
            if success {
                self.filteredAds = adoptionAds
                print(adoptionAds[0].imageURLs)
                NetworkWrapper.getImages(ads: adoptionAds) {
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
                filtersDict["dateBefore"] = "\(Int(to.timeIntervalSince1970))"
            } else {
                filtersDict["dateBefore"] = "\(Int(Date().timeIntervalSince1970))"
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
            addSpinner(spinner)
            NetworkWrapper.getFilteredAds(type: .adoption, filters: filtersDict) { (success) in
                if success {
                    self.filteredAds = adoptionAds
                    print(adoptionAds.count)
                    NetworkWrapper.getImages(ads: adoptionAds) {
                        self.tableView.reloadData()
                    }
                    self.removeSpinner(self.spinner)
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
        NetworkWrapper.getAds(type: .adoption) { success in
            if success {
                self.filteredAds = adoptionAds
                print(adoptionAds.count)
                self.refreshControl.endRefreshing()
                NetworkWrapper.getImages(ads: adoptionAds) {
                    self.tableView.reloadData()
                }
            } else {
                self.showAlertWithTitle("Error loading data", message: "Something went wrong, data could not be downloaded")
            }
        }
    }
}

// MARK: - UITableView delegate and data source
extension AdoptionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertismentCell", for: indexPath) as? AdvertismentCell {
            
            let ad = filteredAds[indexPath.row]
            var image = UIImage(named: "art")!
            if adoptImagesDict.count > 0 && ad.imageURLs.count > 0 {
                image = adoptImagesDict[ad.imageURLs[0]] ?? UIImage(named: "art")!
            }
            cell.configureCell(ad: ad, image: image)
            return cell
        } else {
            return AdvertismentCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.adoptionDetails.rawValue, sender: filteredAds[indexPath.row])
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
extension AdoptionVC: UISearchBarDelegate {
    // Dismiss keyboard when Search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filteredAds.removeAll()
        for ad in adoptionAds {
            if let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces).capitalized, !searchText.isEmpty {
                if ad.town.hasPrefix(searchText) {
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
        filteredAds = adoptionAds
        tableView.reloadData()
        animate(view: searchView, constraint: searchViewHeight, to: 0)
    }
}
