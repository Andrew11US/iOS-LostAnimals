//
//  AddVC.swift
//  LostAnimals
//
//  Created by Andrew on 5/14/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import SPPermissions
import YPImagePicker

class AddVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    @IBOutlet weak var openPickerBtn: CustomButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    // MARK: Variables
    private var permissions: [SPPermission] = [.camera, .photoLibrary, .locationWhenInUse]
    private var images: [UIImage] = []
    
    // ViewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()

        imagesScrollView.delegate = self
    }
    
    // ViewDidAppear method
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in
            self.requestPermissions()
        }
    }
    
    @IBAction func openPickerBtnTapped(_ sender: CustomButton) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 5
        
        let picker = YPImagePicker(configuration: config)
        show(picker, sender: nil)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                    self.images.append(photo.image)
                case .video(let video):
                    print(video)
                }
            }
            self.populateImagesScrollView()
            picker.dismiss(animated: true, completion: nil)
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

    
    
    // MARK: - Request mandatory authrizations method
    private func requestPermissions() {
        var notAuthorized = false
        for permission in permissions {
            if !permission.isAuthorized {
                notAuthorized = true
            }
        }
        
        if notAuthorized {
            let controller = SPPermissions.dialog(permissions)
            controller.present(on: self)
        }
    }

}

// MARK: - UIScrollView delegate
extension AddVC: UIScrollViewDelegate {
    // Show changing pages on PageControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
