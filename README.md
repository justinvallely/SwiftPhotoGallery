# SwiftPhotoGallery

[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20tvOS-blue.svg?style=flat)](http://cocoapods.org/pods/SwiftPhotoGallery)
[![Version](https://img.shields.io/cocoapods/v/SwiftPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/SwiftPhotoGallery)
[![License](https://img.shields.io/cocoapods/l/SwiftPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/SwiftPhotoGallery)
[![CocoaPods](https://img.shields.io/cocoapods/dt/SwiftPhotoGallery.svg?style=flat)](https://cocoapods.org/pods/SwiftPhotoGallery)
![tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Dependencies](https://img.shields.io/badge/dependencies-none-lightgrey.svg?style=flat)

## Overview

A full screen photo gallery for iOS and tvOS written in Swift.

<p align="center">
    <img src="https://s3.amazonaws.com/inspirato-ios/SwiftPhotoGallery_animation.gif">
</p>

- Photos can be panned and zoomed (iOS only)
- Pinch to zoom (iOS only)
- Double tap to zoom all the way in and again to zoom all the way out (iOS only)
- Single tap to close
- Twitter style swipe to close (iOS only)
- Includes a customizable page indicator
- Support for any orientation (iOS only)
- Supports images of varying sizes
- Includes unit tests
- Customize nearly all UI aspects
- Integrates seamlessly with [SDWebImage](https://cocoapods.org/pods/SDWebImage)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory.

## Requirements
- iOS 9.0+
- tvOS 10.0+
- Xcode 10.2.1+
- Swift 5.0+

## Communication

- If you **need help**, use [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftphotogallery). (Tag 'swiftphotogallery')
- If you'd like to **ask a general question**, use [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftphotogallery).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

SwiftPhotoGallery is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```swift
pod 'SwiftPhotoGallery'
```

## Implementation

* **Import the framework in your view controller**
```swift
import SwiftPhotoGallery
```

* **Create an instance**
```swift
let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
```

* **Customize the look**
```swift
gallery.backgroundColor = UIColor.black
gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
gallery.currentPageIndicatorTintColor = UIColor.white
gallery.hidePageControl = false
```

* **Implement the datasource**
```swift
let imageNames = ["image1.jpeg", "image2.jpeg", "image3.jpeg"]

func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
    return imageNames.count
}

func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
    return UIImage(named: imageNames[forIndex])
}
```

* **Implement the delegate**
```swift
func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
    // do something cool like:
    dismiss(animated: true, completion: nil)
}
```

* **Present the gallery**
```swift
present(gallery, animated: true, completion: nil)
```




## Full Example
```swift
class ViewController: UIViewController, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {

    let imageNames = ["image1.jpeg", "image2.jpeg", "image3.jpeg"]
    var index: Int = 2

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didPressShowMeButton(sender: AnyObject) {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false

        present(gallery, animated: true, completion: nil)

        /*
        /// Or load on a specific page like this:

        present(gallery, animated: true, completion: { () -> Void in
            gallery.currentPage = self.index
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
```


## Author

Justin Vallely, justinvallely@gmail.com

## License

SwiftPhotoGallery is available under the Apache License 2.0. See the LICENSE file for more info.
