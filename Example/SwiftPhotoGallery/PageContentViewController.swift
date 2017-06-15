//
//  PageContentViewController.swift
//  SwiftPhotoGallery
//
//  Created by Justin Vallely on 6/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SwiftPhotoGallery

class PageContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var imageNames = [String]()
    var pageIndex: Int = 0
    var titleText: String = ""
    var imageFile: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: imageFile)
        titleLabel?.text = titleText

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
    }

    func imageTapped() {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor(red: 0.0, green: 0.66, blue: 0.875, alpha: 1.0)
        gallery.hidePageControl = false
        gallery.modalPresentationStyle = .custom
        gallery.transitioningDelegate = self

        //        present(gallery, animated: true, completion: nil)

        /// Or load on a specific page like this:

        present(gallery, animated: true, completion: { () -> Void in
            gallery.currentPage = self.pageIndex
        })
    }
}


// MARK: SwiftPhotoGalleryDataSource Methods
extension PageContentViewController: SwiftPhotoGalleryDataSource {

    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageNames.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return UIImage(named: imageNames[forIndex])
    }
}


// MARK: SwiftPhotoGalleryDelegate Methods
extension PageContentViewController: SwiftPhotoGalleryDelegate {

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: UIViewControllerTransitioningDelegate Methods
extension PageContentViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
}
