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

    var date: String = ""
    
    // MARK: - Lazy properties (calculated only when first time is used)
    lazy var monthLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .black
        label.text = "Current month"
        return label
    }()
    
    // Koyomi calendar programmatically
    lazy var calendar: Koyomi = {
        // Centering on the view
        let frame = CGRect(x: self.bounds.width/2 - 150, y : self.bounds.height/2 + 50, width: 300, height: 200)
        let calendar = Koyomi(frame: frame, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
        // Calendar UI setup
        calendar.layer.cornerRadius = 7
        calendar.circularViewDiameter = 0.2
        calendar.calendarDelegate = self
        calendar.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        calendar.weeks = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
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
        button.addTarget(self, action: #selector(previousTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var currentBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Current", for: .normal)
        button.addTarget(self, action: #selector(currentTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
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
    
    lazy var stackView1: UIStackView = {
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
        backgroundColor = .green
        
        stackView.addArrangedSubview(previousBtn)
        stackView.addArrangedSubview(currentBtn)
        stackView.addArrangedSubview(nextBtn)
        stackView1.addArrangedSubview(monthLbl)
        addSubview(calendar)
        addSubview(stackView)
        addSubview(stackView1)
        
        monthLbl.text = calendar.currentDateString()
        
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView1.bottomAnchor.constraint(equalTo: self.calendar.topAnchor, constant: 0),
            stackView1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: self.calendar.bottomAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
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
            monthLbl.text = "\(dateFrom.getShort)"
            if let dateTo = toDate {
                monthLbl.text = "\(dateFrom.getShort) - \(dateTo.getShort)"
            }
            return true
        }
        return false
    }
}
