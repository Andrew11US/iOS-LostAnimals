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
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Variables
    private var images: [UIImage] = [UIImage(named: "t1")!, UIImage(named: "t2")!, UIImage(named: "t3")!, UIImage(named: "test")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        horizontalScrollView.delegate = self
        populateHorizontalScrollView()
    }
    
    private func populateHorizontalScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = images[i]
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: CGFloat(215))
            
            horizontalScrollView.contentSize.width = horizontalScrollView.frame.width * CGFloat(i + 1)
            horizontalScrollView.addSubview(imageView)
        }
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        verticalScrollView.bringSubviewToFront(pageControl)
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
