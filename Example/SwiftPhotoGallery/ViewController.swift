//
//  ViewController.swift
//  SwiftPhotoGallery
//
//  Created by Justin Vallely on 08/25/2015.
//  Copyright (c) 2015 Justin Vallely. All rights reserved.
//

import UIKit
import SwiftPhotoGallery

class ViewController: UIViewController, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {

    let imageNames = ["image.png", "pano.jpg", "slide1@3x.png", "slide2@3x.png", "slide3@3x.png", "slide4@3x.png"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressShowMeButton(sender:AnyObject) {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        presentViewController(gallery, animated: true, completion: nil)
    }

    // MARK: SwiftPhotoGalleryDataSource Methods

    func numberOfImagesInGallery(gallery:SwiftPhotoGallery) -> Int {
        return imageNames.count
    }

    func imageInGallery(gallery:SwiftPhotoGallery, forIndex:Int) -> UIImage? {

        return UIImage(named: imageNames[forIndex])
    }

    // MARK: SwiftPhotoGalleryDelegate Methods

    func galleryDidTapToClose(gallery:SwiftPhotoGallery) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

