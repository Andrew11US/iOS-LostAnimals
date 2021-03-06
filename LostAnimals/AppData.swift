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
    case adoption = "to-adopt"
}

public enum AnimalType: String, CaseIterable {
    case cat = "cat"
    case dog = "dog"
    case snake = "snake"
    case lizard = "lizard"
}

// MARK: - Data collections
var lostAds: [Advertisment] = []
var foundAds: [Advertisment] = []
var adoptionAds: [Advertisment] = []

var lostImagesDict: [String: UIImage] = [:]
var foundImagesDict: [String: UIImage] = [:]
var adoptImagesDict: [String: UIImage] = [:]

