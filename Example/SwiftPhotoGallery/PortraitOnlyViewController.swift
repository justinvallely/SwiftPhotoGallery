//
//  PortraitOnlyViewController.swift
//  SwiftPhotoGallery
//
//  Created by Justin Vallely on 9/15/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


class PortraitOnlyViewController: UIViewController {
    // MARK: Rotation Handling

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
