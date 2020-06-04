//
//  CalendarView.swift
//  LostAnimals
//
//  Created by Andrew on 5/19/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Koyomi

class CalendarView: UIView {

    public var dates: (from: Date, to: Date?) = (Date(), nil)
    
    // MARK: - Lazy properties (calculated only when first time is used)
    lazy var monthLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .label
        label.text = "Current month"
        return label
    }()
    
    // Koyomi calendar programmatically
    lazy var calendar: Koyomi = {
        // Centering on the view
        let frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y : self.bounds.height/2 + 80, width: 300, height: 200)
        let calendar = Koyomi(frame: frame, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
        // Calendar UI setup
        calendar.layer.cornerRadius = 7
        calendar.circularViewDiameter = 0.2
        calendar.calendarDelegate = self
        calendar.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        calendar.weeks = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
        calendar.style = .standard
        calendar.dayPosition = .center
        calendar.selectionMode = .sequence(style: .semicircleEdge)
        calendar.selectedStyleColor = .systemRed
        calendar
            .setDayFont(size: 14)
            .setWeekFont(size: 14)
        return calendar
    }()
    
    lazy var previousBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Previous", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        button.addTarget(self, action: #selector(previousTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var currentBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Current", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        button.addTarget(self, action: #selector(currentTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        button.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var topStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var bottomStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
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
        backgroundColor = .systemBackground
        
        topStack.addArrangedSubview(monthLbl)
        
        stackView.addArrangedSubview(previousBtn)
        stackView.addArrangedSubview(currentBtn)
        stackView.addArrangedSubview(nextBtn)
        topStack.addArrangedSubview(stackView)
        
        addSubview(calendar)
        addSubview(bottomStack)
        addSubview(topStack)
        
        monthLbl.text = calendar.currentDateString()
        
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            topStack.bottomAnchor.constraint(equalTo: self.calendar.topAnchor, constant: 0),
            topStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            topStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            bottomStack.heightAnchor.constraint(equalToConstant: 40),
            bottomStack.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            bottomStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            bottomStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Action functions
    @objc func previousTapped(_ sender: UIButton!) {
        calendar.display(in: .previous)
        monthLbl.text = calendar.currentDateString()
        print("Previous")
    }
    
    @objc func currentTapped(_ sender: UIButton!) {
        calendar.display(in: .current)
        monthLbl.text = calendar.currentDateString()
        print("Current")
    }
    
    @objc func nextTapped(_ sender: UIButton!) {
        calendar.display(in: .next)
        monthLbl.text = calendar.currentDateString()
        print("Next")
    }

}

// MARK: - Koyomi calendar Delegate
extension CalendarView: KoyomiDelegate {
//    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
//        guard let date = date else { return }
//        monthLbl.text = "\(date.getShort)"
//    }
    
    // Select one day or range between
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {

        if let dateFrom = date {
//            dates = "\(dateFrom.getShort)"
            dates.from = dateFrom
            monthLbl.text = dateFrom.getShort
            if let dateTo = toDate {
//                dates = "\(dateFrom.getShort) - \(dateTo.getShort)"
//                monthLbl.text = dates
                dates.to = dateTo
                monthLbl.text = "\(dateFrom.getShort) - \(dateTo.getShort)"
            }
            return true
        }
        return false
    }
}
