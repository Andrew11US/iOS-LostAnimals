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
    @IBOutlet weak var filterBase: UIView!
    @IBOutlet weak var filterBaseHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarBase: UIView!
    @IBOutlet weak var calendarBaseHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var animalTypeBtn: DropMenuButton!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var chipTextField: UITextField!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var cancelCalendarBtn: CustomButton!
    @IBOutlet weak var applyDatesBtn: CustomButton!
    
    // MARK: - Variables
    private var calendarView: CalendarView!
    private var filterView: FilterView!
    private var filteredAds: [Advertisment] = advertisments
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.dateTextField.delegate = self
        self.cityTextField.delegate = self
        self.regionTextField.delegate = self
        self.chipTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setDoneToolBar(field: chipTextField)
        populateAnimalTypes()
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
            resignTextFields()
        } else {
            setupFilterView()
            self.animate(view: filterBase, constraint: filterBaseHeight, to: 400)
            self.animate(view: searchView, constraint: searchViewHeight, to: 0)
        }
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Filter button actions
    @IBAction func typeChanged(_ sender: Any) {
        
    }
    
    @IBAction func showPickerTapped(_ sender: UIButton) {
        resignTextFields()
    }
    
    @IBAction func showCalendarTapped(_ sender: UIButton) {
        setupCalendarView()
        resignTextFields()
        self.animate(view: calendarBase, constraint: calendarBaseHeight, to: 350)
    }
    
    // MARK: - Calendar actions
    @IBAction func applyDatesTapped(_ sender: UIButton) {
        dateTextField.text = calendarView.selectedDates
        self.animate(view: calendarBase, constraint: calendarBaseHeight, to: 0)
    }
    
    @IBAction func cancelCalendarTapped(_ sender: UIButton) {
        dateTextField.text = ""
        self.animate(view: calendarBase, constraint: calendarBaseHeight, to: 0)
    }
    
    // MARK: - Filter actions
    @IBAction func cancelTapped(_ sender: CustomButton) {
        self.animate(view: filterBase, constraint: filterBaseHeight, to: 0)
        resignTextFields()
    }
    
    @IBAction func applyTapped(_ sender: CustomButton) {
        // TODO: make filtering
        self.animate(view: filterBase, constraint: filterBaseHeight, to: 0)
        resignTextFields()
    }
    
    // MARK: - Filter field actions
    @IBAction func dateTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func cityTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func regionTextFieldChanged(_ sender: UITextField) {
    }
    
    @IBAction func chipTextFieldChanged(_ sender: UITextField) {
    }
    
    private func populateAnimalTypes() {
        animalTypeBtn.initMenu(["Cat", "Dog", "Spider", "Lizard"])
    }
    
    // Initializing views
    private func setupCalendarView() {
        calendarView = CalendarView(frame: calendarBase.bounds)
        calendarBase.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarBase.topAnchor, constant: 0),
            calendarView.bottomAnchor.constraint(equalTo: calendarBase.bottomAnchor, constant: -60),
            calendarView.trailingAnchor.constraint(equalTo: calendarBase.trailingAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: calendarBase.leadingAnchor, constant: 0)
        ])
    }
    
    private func setupFilterView() {
        filterView = FilterView(frame: filterBase.bounds)
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

// MARK: - TextField Delegate methods
extension LostVC: UITextFieldDelegate {
    // Dismiss keyboard on touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss when return btn pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        regionTextField.resignFirstResponder()
        chipTextField.resignFirstResponder()
        return true
    }
    
    func resignTextFields() {
        dateTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        regionTextField.resignFirstResponder()
        chipTextField.resignFirstResponder()
    }
    
    private func setDoneToolBar(field: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar()
        
        doneToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        ]
        doneToolbar.sizeToFit()
        field.inputAccessoryView = doneToolbar
    }
    
    @objc private func dismissKeyboard() {
        chipTextField.resignFirstResponder()
    }
}

