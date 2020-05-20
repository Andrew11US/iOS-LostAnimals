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
    @IBOutlet weak var downloadPDFBtn: CustomButton!
    
    // MARK: - Variables
    private var images: [UIImage] = [UIImage(named: "t1")!, UIImage(named: "t2")!, UIImage(named: "t3")!, UIImage(named: "test")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagesScrollView.delegate = self
        populateImagesScrollView()
        setBoilerplate()
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
    
    func setBoilerplate() {
        descLbl.text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus viverra nibh vel gravida cursus. Integer quis dignissim sapien. Praesent vulputate sapien id molestie accumsan. Integer eu aliquet arcu. Nunc scelerisque odio justo, ac ultricies sapien semper eu. In et bibendum diam. Cras dignissim risus in felis placerat convallis. Curabitur at massa quis metus ultricies ullamcorper. Mauris sit amet ex quis tortor ultrices ullamcorper. Donec sit amet lobortis dolor. Suspendisse urna libero, efficitur eget nunc id, dictum vehicula massa. Morbi at nisi vel orci pulvinar fringilla sed sagittis nulla. Nulla lectus orci, bibendum ut viverra et, fermentum sed felis. Fusce tortor sapien, euismod ut congue in, ornare in orci.

Duis hendrerit tristique est, at euismod tortor sagittis a. Fusce a mi et magna tempus placerat. Vestibulum elit justo, iaculis at augue quis, ullamcorper feugiat nunc. Proin vehicula pellentesque turpis eu aliquam. Vivamus ultricies gravida aliquet. Fusce quis euismod metus, in tempus tellus. Nam at dui interdum, molestie metus vel, gravida quam. Proin non bibendum felis. Nam porta eleifend lobortis. Nullam ut elit vestibulum, consequat odio ac, laoreet neque.
"""
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
