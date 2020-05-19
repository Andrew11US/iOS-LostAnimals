//
//  FilterView.swift
//  LostAnimals
//
//  Created by Andrew on 5/19/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class FilterView: UIView {

    public var selectedDates: String = ""
    public var selectedAnimalType: String = ""
    
    private let animalTypes: [String] = ["Cat", "Dog", "Spider", "Lizard"]
    private var calendarView: CalendarView!
    
    // MARK: - Lazy properties (calculated only when first time is used)
    lazy var nameLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.textColor = .black
        label.text = "Filters"
        return label
    }()
    
    lazy var animalTypeBtn: CustomButton = {
        let button = CustomButton()
        button.setTitle("Animal Type", for: .normal)
        button.addTarget(self, action: #selector(showAnimalPickerTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var animalPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = true
        return picker
    }()
    
    lazy var dateTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        field.placeholder = "Enter date"
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(validateDate(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var cityTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        field.placeholder = "City"
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(validateCity(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var regionTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        field.placeholder = "Region"
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(validateRegion(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var chipTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        field.placeholder = "Chip number"
        field.keyboardType = .numberPad
        field.returnKeyType = .done
        field.addTarget(self, action: #selector(validateChip(_:)), for: .editingDidEnd)
        return field
    }()
    
    lazy var calendarBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        button.setTitle("C", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(showCalendarTapped(_:)), for: .touchUpInside)
        return button
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

    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    lazy var spacer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    // MARK: - View setup
    private func setupView() {
        backgroundColor = .systemPink
        self.animalPicker.delegate = self
        self.animalPicker.dataSource = self
        dateTextField.delegate = self
        cityTextField.delegate = self
        regionTextField.delegate = self
        chipTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        setDoneToolBar(field: chipTextField)
        
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(animalTypeBtn)
        stackView.addArrangedSubview(animalPicker)
        stackView2.addArrangedSubview(dateTextField)
        stackView2.addArrangedSubview(calendarBtn)
        stackView.addArrangedSubview(stackView2)
        stackView.addArrangedSubview(cityTextField)
        stackView.addArrangedSubview(regionTextField)
        stackView.addArrangedSubview(chipTextField)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: - Action functions
    @objc func showCalendarTapped(_ sender: UIButton!) {
        calendarView = CalendarView()
        addSubview(calendarView)
        stackView.isHidden = true
        
        calendarStack.addArrangedSubview(cancelCalendarBtn)
        calendarStack.addArrangedSubview(applyDatesBtn)
        calendarView.bottomStack.addArrangedSubview(calendarStack)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            calendarView.heightAnchor.constraint(equalToConstant: 340),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        ])
    }
    
    @objc func showAnimalPickerTapped(_ sender: UIButton!) {
        animalPicker.isHidden = false
        animalTypeBtn.isHidden = true
    }
    
    @objc func applyDatesTapped(_ sender: UIButton!) {
        self.selectedDates = calendarView.selectedDates
        dateTextField.text = selectedDates
        calendarView.isHidden = true
        stackView.isHidden = false
    }
    
    @objc func cancelCalendarTapped(_ sender: UIButton!) {
        calendarView.isHidden = true
        stackView.isHidden = false
    }
    
    // MARK: - Text fields validatiors
    @objc func validateDate(_ sender: UITextField!) {
        // TODO: - make validations
    }
    
    @objc func validateCity(_ sender: UITextField!) {
        // TODO: - make validations
    }
    
    @objc func validateRegion(_ sender: UITextField!) {
        // TODO: - make validations
    }
    
    @objc func validateChip(_ sender: UITextField!) {
        // TODO: - make validations
    }
    


}

// MARK: - UIImagePicker delegate
extension FilterView: UIPickerViewDelegate, UIPickerViewDataSource {
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
        selectedAnimalType = animalTypes[row]
        animalTypeBtn.setTitle(animalTypes[row], for: .normal)
        animalTypeBtn.isHidden = false
        pickerView.isHidden = true
    }
}

// MARK: - TextField delegate
extension FilterView: UITextFieldDelegate {
    // Keyboard handling
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
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
}
