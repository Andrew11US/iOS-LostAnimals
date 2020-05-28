//
//  AddVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import SPPermissions
import YPImagePicker

class AddVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var imagePickerBtn: CustomButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var animalTypeBtn: CustomButton!
    @IBOutlet weak var calendarBtn: CustomButton!
    @IBOutlet weak var adTypeSegment: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var chipTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var publishBtn: CustomButton!
    
    
    // MARK: Variables
    private var calendarView: CalendarView!
    private var ad: Advertisment!
    private var permissions: [SPPermission] = [.camera, .photoLibrary, .locationWhenInUse]
    private var images: [UIImage] = []
    private let animalTypes: [String] = ["Cat", "Dog", "Spider", "Lizard"]
    private var animalType: String = ""
    private var selectedDates: String = ""
    private var adType: String = ""
    private var city: String = ""
    private var district: String = ""
    private var phone: String = ""
    private var chip: String = ""
    private var name: String = ""
    private var desc: String = ""
    
    // MARK: - Programmatic views
    lazy var animalPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    lazy var calendarStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Calendar buttons
    lazy var applyDatesBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(applyDatesTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelCalendarBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(cancelCalendarTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // ViewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()

        imagesScrollView.delegate = self
        animalPicker.delegate = self
        animalPicker.dataSource = self
        dateTextField.delegate = self
        cityTextField.delegate = self
        regionTextField.delegate = self
        chipTextField.delegate = self
        nameTextField.delegate = self
        phoneTextField.delegate = self
        
        setDoneToolBar(field: chipTextField)
        setDoneToolBar(field: phoneTextField)
        setDoneToolBar(field: descriptionTextView)
    }
    
    // ViewDidAppear method
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in
            self.requestPermissions()
        }
    }
    
    @IBAction func openPickerTapped(_ sender: AnyObject) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 5
        config.library.mediaType = .photo
        config.showsPhotoFilters = false
        config.usesFrontCamera = false
        config.shouldSaveNewPicturesToAlbum = false
        config.hidesStatusBar = false
        
        let picker = YPImagePicker(configuration: config)
        show(picker, sender: nil)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("User did cancel picking")
                picker.dismiss(animated: true, completion: nil)
            }
            
            if items.count > 0 {
                self.images.removeAll()
                for s in self.imagesScrollView.subviews {
                    s.removeFromSuperview()
                }
                
                for item in items {
                    switch item {
                    case .photo(let photo):
                        self.images.append(photo.image)
                    case .video: break
                    }
                }
                self.populateImagesScrollView()
                self.pageControl.isHidden = false
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func animalTypeBtnTapped(_ sender: CustomButton) {
        mainStack.insertArrangedSubview(animalPicker, at: 2)
        
        NSLayoutConstraint.activate([
            animalPicker.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        animalPicker.isHidden = false
        animalTypeBtn.isHidden = true
    }
    
    @IBAction func calendarBtnTapped(_ sender: CustomButton) {
        calendarView = CalendarView()
        verticalContentView.addSubview(calendarView)
        verticalContentView.bringSubviewToFront(calendarView)
        
        calendarStack.addArrangedSubview(cancelCalendarBtn)
        calendarStack.addArrangedSubview(applyDatesBtn)
        calendarView.bottomStack.addArrangedSubview(calendarStack)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: verticalContentView.topAnchor, constant: 0),
            calendarView.heightAnchor.constraint(equalToConstant: 340),
            calendarView.trailingAnchor.constraint(equalTo: verticalContentView.trailingAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: verticalContentView.leadingAnchor, constant: 0)
        ])
    }
    
    @objc func applyDatesTapped(_ sender: UIButton!) {
        self.selectedDates = calendarView.selectedDates
        dateTextField.text = selectedDates
        calendarView.isHidden = true
    }
    
    @objc func cancelCalendarTapped(_ sender: UIButton!) {
        calendarView.isHidden = true
    }
    
    @IBAction func publishTapped(_ sender: CustomButton) {
        if adTypeSegment.selectedSegmentIndex == 0 {
            adType = AdType.lost.rawValue
        } else if adTypeSegment.selectedSegmentIndex == 1 {
            adType = AdType.found.rawValue
        } else {
            adType = AdType.adoption.rawValue
        }
        animalType = animalTypeBtn.title(for: .normal)!
        name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        selectedDates = dateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        city = cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        district = regionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        phone = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        chip = chipTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        desc = descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        ad = Advertisment(type: adType, animalType: animalType, animalName: name, date: selectedDates, city: city, district: district, phone: phone, chipNumber: Int(chip)!, description: desc)
//        advertisments.append(ad)
        
        // clarify arguments to upload
        let data: [String: String] = [
            "chipNumber": chip,
            "description": desc,
            "distinguishingMarks": "string",
            "district": district,
            "email": "string",
            "id": "0",
            "image": "string",
            "lostDate": selectedDates,
            "name": name,
            "phoneNumber": phone,
            "propertyNumber": "string",
            "state": "string",
            "street": "string",
            "title": "string",
            "town": city,
            "type": "string"
        ]
        
        NetworkWrapper.publishAd(type: adType, data: data) { success in
            if success {
                print("uploaded")
            }
        }
    }
    
    private func populateImagesScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = images[i]
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: CGFloat(215))
            
            imagesScrollView.contentSize.width = imagesScrollView.frame.width * CGFloat(i + 1)
            imagesScrollView.addSubview(imageView)
        }
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        verticalScrollView.bringSubviewToFront(pageControl)
    }

    
    
    // MARK: - Request mandatory authrizations method
    private func requestPermissions() {
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

// MARK: - UIScrollView delegate
extension AddVC: UIScrollViewDelegate {
    // Show changing pages on PageControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

// MARK: - UIImagePicker delegate
extension AddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return animalTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return animalTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        animalType = animalTypes[row]
        animalTypeBtn.setTitle(animalTypes[row], for: .normal)
        animalTypeBtn.isHidden = false
        pickerView.isHidden = true
    }
}

// MARK: - TextField delegate
extension AddVC: UITextFieldDelegate {
    // Keyboard handling
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setDoneToolBar(field: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar()
        
        doneToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        ]
        doneToolbar.sizeToFit()
        field.inputAccessoryView = doneToolbar
    }
    
    func setDoneToolBar(field: UITextView) {
        let doneToolbar: UIToolbar = UIToolbar()
        
        doneToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        ]
        doneToolbar.sizeToFit()
        field.inputAccessoryView = doneToolbar
    }
}

