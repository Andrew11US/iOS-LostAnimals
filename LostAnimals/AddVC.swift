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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var animalTypeBtn: CustomButton!
    @IBOutlet weak var calendarBtn: CustomButton!
    @IBOutlet weak var resetBtn: CustomButton!
    @IBOutlet weak var adTypeSegment: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var chipTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var distingMarksTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var publishBtn: CustomButton!
    
    // MARK: Variables
    private var spinner = Spinner()
    private var calendarView: CalendarView!
    private var ad: Advertisment!
    private var permissions: [SPPermission] = [.camera, .photoLibrary]
    private var images: [UIImage] = []
    private let animalTypes: [String] = ["Cat", "Dog", "Spider", "Lizard"]
    private var dates: (from: Date, to: Date?) = (Date(), nil)
    private var animalType: String = ""
    private var adType: String = ""
    
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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        button.addTarget(self, action: #selector(applyDatesTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelCalendarBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
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
        distingMarksTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        streetTextField.delegate = self
        nameTextField.delegate = self
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        
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
        self.dates = calendarView.dates
        dateTextField.text = dates.from.getShort
        calendarView.isHidden = true
    }
    
    @objc func cancelCalendarTapped(_ sender: UIButton!) {
        calendarView.isHidden = true
    }
    
    @IBAction func resetTapped(_ sender: CustomButton) {
        animalType = "Animal Type"
        animalTypeBtn.setTitle(animalType, for: .normal)
        cityTextField.text?.removeAll()
        dateTextField.text?.removeAll()
        phoneTextField.text?.removeAll()
        emailTextField.text?.removeAll()
        titleTextField.text?.removeAll()
        chipTextField.text?.removeAll()
        regionTextField.text?.removeAll()
        regionTextField.text?.removeAll()
        streetTextField.text?.removeAll()
        nameTextField.text?.removeAll()
        distingMarksTextField.text?.removeAll()
        descriptionTextView.text?.removeAll()
        images.removeAll()
        
        for s in self.imagesScrollView.subviews {
            s.removeFromSuperview()
        }
    }
    
    @IBAction func publishTapped(_ sender: CustomButton) {
        var data: [String: AnyObject] = [:]
        
        switch adTypeSegment.selectedSegmentIndex {
        case 0: adType = AdType.lost.rawValue
        case 1: adType = AdType.found.rawValue
        default: adType = AdType.adoption.rawValue
        }
        
        if images.count > 0 {
            var arr : [AnyObject] = []

            for image in images {
                let imgBase64 = image.toBase64(format: .jpeg(80)) ?? ""
                let dict: [String: String] = ["image": imgBase64]
                arr.append(dict as AnyObject)
            }
            data["photos"] = arr as AnyObject
        } else {
            showAlertWithTitle("Image error", message: "Unable to process the image, JPEG expected")
            return
        }
        
        if animalType != "Animal Type" {
            data["type"] = animalType as AnyObject
        } else {
            self.showAlertWithTitle("Compound error", message: "Animal type should be selected")
            return
        }
        
        if let town = Validator.validate.text(field: cityTextField) {
            data["town"] = town as AnyObject
        } else {
            self.showAlertWithTitle("Compound error", message: "Town should be provided")
            return
        }
        
        if let phone = Validator.validate.text(field: phoneTextField) {
            data["phoneNumber"] = phone as AnyObject
        } else {
            self.showAlertWithTitle("Compound error", message: "Phone should be provided")
            return
        }
        
        if let email = Validator.validate.text(field: emailTextField) {
            data["email"] = email as AnyObject
        } else {
            self.showAlertWithTitle("Compound error", message: "Email should be provided")
            return
        }
        
        if let title = Validator.validate.text(field: titleTextField) {
            data["title"] = title as AnyObject
        } else {
            self.showAlertWithTitle("Compound error", message: "Title should be provided")
            return
        }
        
        if let chip = Validator.validate.text(field: chipTextField) {
            data["chipNumber"] = chip as AnyObject
        } else {
            self.showAlertWithTitle("Compound error", message: "Chip number should be provided")
            return
        }
        
        if let district = Validator.validate.text(field: regionTextField) {
            data["district"] = district as AnyObject
        }
        
        if let street = Validator.validate.text(field: streetTextField) {
            data["street"] = street as AnyObject
        }
        
        if let distingMarks = Validator.validate.text(field: distingMarksTextField) {
            data["distinguishingMarks"] = distingMarks as AnyObject
        }
        
        if let name = Validator.validate.text(field: nameTextField) {
            data["name"] = name as AnyObject
        }
        
        if let description = Validator.validate.text(field: descriptionTextView) {
            data["description"] = description as AnyObject
        }
        
        data["lostDate"] = Int(dates.from.timeIntervalSince1970) as AnyObject
        addSpinner(spinner)
        NetworkWrapper.publishAd(type: adType, data: data) { success in
            if success {
                print("ad has been uploaded successfully")
                self.resetTapped(CustomButton())
                self.showAlertWithTitle("Success!", message: "Your advertisment has been succsessfully uploaded")
            } else {
                self.showAlertWithTitle("Error", message: "Could not upload ad, internal error")
            }
            self.removeSpinner(self.spinner)
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
extension AddVC: UITextFieldDelegate, UITextViewDelegate {
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

