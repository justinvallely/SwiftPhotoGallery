//
//  ViewController.swift
//  SwiftPhotoGallery
//
//  Created by Justin Vallely on 08/25/2015.
//  Copyright (c) 2015 Justin Vallely. All rights reserved.
//

import UIKit
import SwiftPhotoGallery

class HeaderViewController: UIViewController {

    @IBAction func unwindToMainMenu(_ sender: UIStoryboardSegue) {
        let _: AnyObject = sender.source
        // Pull any data from the view controller which initiated the unwind segue.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class ViewController: PortraitOnlyViewController, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {

    let imageNames = ["image1.jpeg", "image2.jpeg", "image3.jpeg"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didPressShowMeButton(_ sender: AnyObject) {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white

        present(gallery, animated: true, completion: nil)

        /// Or load on a specific page like this:
        /*
        present(gallery, animated: false, completion: { () -> Void in
            gallery.currentPage = 2
        })
        */
    }

    // MARK: SwiftPhotoGalleryDataSource Methods

    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageNames.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {

        return UIImage(named: imageNames[forIndex])
    }

    // MARK: SwiftPhotoGalleryDelegate Methods

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    
}

