//
//  PortraitOnlyViewController.swift
//  SwiftPhotoGallery
//
//  Created by Justin Vallely on 9/15/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


class PortraitOnlyViewController:UIViewController {
    // MARK: Rotation Handling

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
}
