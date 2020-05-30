//
//  DetailVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var animalTypeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var chipLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var downloadPDFBtn: CustomButton!
    
    // MARK: - Variables
    public var ad: Advertisment!
    private var images: [UIImage] = [UIImage(named: "t1")!, UIImage(named: "t2")!, UIImage(named: "t3")!, UIImage(named: "test")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesScrollView.delegate = self
//        populateImagesScrollView()
        updateView()
        
        NetworkWrapper.getImage(url: "https://aqueous-anchorage-15610.herokuapp.com/api/lost/1/photo") { (data, success) in
            if success {
                print(data)
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.image = UIImage(data: data)
                let xPosition = self.view.frame.width
                imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(215))
                self.imagesScrollView.contentSize.width = self.imagesScrollView.frame.width * CGFloat(1)
                self.imagesScrollView.addSubview(imageView)
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
    
    func updateView() {
        DispatchQueue.main.async {
            self.locationLbl.text = self.ad.town
            self.nameLbl.text = self.ad.animalName
            self.dateLbl.text = self.ad.date
            self.phoneLbl.text = self.ad.phone
            self.chipLbl.text = String(self.ad.chipNumber)
            self.descLbl.text = self.ad.description
            self.animalTypeLbl.text = self.ad.type
            self.badgeLbl.text = self.ad.state
        }
    }
    
    @IBAction func backTapped(_ sender: CustomButton) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UIScrollView delegate
extension DetailVC: UIScrollViewDelegate {
    // Show changing pages on PageControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
