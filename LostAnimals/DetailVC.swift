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
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var streetLbl: UILabel!
    @IBOutlet weak var districtLbl: UILabel!
    @IBOutlet weak var distMarksLbl: UILabel!
    @IBOutlet weak var downloadPDFBtn: CustomButton!
    
    // MARK: - Variables
    public var ad: Advertisment!
    private var spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesScrollView.delegate = self
        updateView()
        updateImages()
        NetworkWrapper.getByID(type: AdType(rawValue: ad.adType)!, id: ad.id) { (success, ad) in
            if success {
                print(ad)
                self.ad = ad
                self.updateView()
                self.updateImages()
            }
        }
    }
    
    func updateView() {
        self.locationLbl.text = self.ad.town
        self.nameLbl.text = self.ad.animalName
        self.dateLbl.text = self.ad.date
        self.phoneLbl.text = self.ad.phone
        self.chipLbl.text = String(self.ad.chipNumber)
        self.descLbl.text = self.ad.description
        self.animalTypeLbl.text = self.ad.animalType
        self.badgeLbl.text = self.ad.adType
        self.titleLbl.text = self.ad.title
        self.emailLbl.text = self.ad.email
        self.streetLbl.text = self.ad.street
        self.districtLbl.text = self.ad.district
        self.distMarksLbl.text = self.ad.distingMarks
    }
    
    func updateImages() {
        var images: [UIImage] = []
        addSpinner(spinner)
        NetworkWrapper.getImages(urls: ad.imageURLs) { (data, success) in
            if success {
                images.append(UIImage(data: data) ?? UIImage())
            }
            self.populateImagesScrollView(images: images)
            self.removeSpinner(self.spinner)
        }
    }
    
    private func populateImagesScrollView(images: [UIImage]) {
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
        pageControl.isHidden = false
    }
    
    @IBAction func downloadPDFTapped(_ sender: CustomButton) {
        
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        let items = [ad] // data to share
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // If device is iPad anchor rect for alert is needed
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = sender
            activityController.popoverPresentationController?.sourceRect = sender.bounds
            activityController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        present(activityController, animated: true)
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
