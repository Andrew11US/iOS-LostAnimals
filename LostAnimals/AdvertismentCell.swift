//
//  AdvertismentCell.swift
//  LostAnimals
//
//  Created by Andrew on 5/17/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class AdvertismentCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.layer.cornerRadius = 12
        badgeLbl.layer.cornerRadius = badgeLbl.bounds.height / 2
        badgeLbl.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(ad: Advertisment, image: UIImage) {
        self.imgView.image = image
        self.badgeLbl.text = ad.adType.capitalized
        self.nameLbl.text = ad.date
        self.locationLbl.text = ad.town
        
        switch AdType(rawValue: ad.adType) {
        case .lost: badgeLbl.layer.backgroundColor = UIColor.badgeRed.cgColor
        case .found: badgeLbl.layer.backgroundColor = UIColor.badgeGreen.cgColor
        case .adoption: badgeLbl.layer.backgroundColor = UIColor.badgeYellow.cgColor
        default:
            badgeLbl.layer.backgroundColor = UIColor.red.cgColor
        }
    }
}
