//
//  AppData.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

public enum AdType: String, CaseIterable {
    case lost = "lost"
    case found = "found"
    case adoption = "adoption"
}

public enum AnimalType: String, CaseIterable {
    case cat = "cat"
    case dog = "dog"
    case snake = "snake"
    case lizard = "lizard"
}

// MARK: - Data collections
var advertisments: [Advertisment] = [
    Advertisment(type: AdType.lost.rawValue, animalType: AnimalType.cat.rawValue, animalName: "Boris", date: "11-05-2020", city: "Warsaw", district: "center", phone: "888", chipNumber: 12345, description: "Lost cat"),
    Advertisment(type: AdType.found.rawValue, animalType: AnimalType.cat.rawValue, animalName: "Boris2", date: "12-05-2020", city: "Warsaw", district: "center", phone: "111", chipNumber: 12345, description: "Found cat")
]
