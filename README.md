# SwiftPhotoGallery

[![Version](https://img.shields.io/cocoapods/v/SwiftPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/SwiftPhotoGallery)
[![License](https://img.shields.io/cocoapods/l/SwiftPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/SwiftPhotoGallery)
[![Platform](https://img.shields.io/cocoapods/p/SwiftPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/SwiftPhotoGallery)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

-Pinch to zoom.
-Double tap to zoom all the way in and again to zoom all the way out.
-Single tap to close.

-Supports images of varying sizes.

-Includes unit test.

## Requirements
iOS 8.3 and above

## Installation

SwiftPhotoGallery is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftPhotoGallery"
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
gallery.backgroundColor = UIColor.blackColor()
gallery.pageIndicatorTintColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
gallery.currentPageIndicatorTintColor = UIColor.whiteColor()
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
  dismissViewControllerAnimated(true, completion: nil)
}
```


* **Full example:**
```swift
class ViewController: UIViewController, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {

    let imageNames = ["image1.jpeg", "image2.jpeg", "image3.jpeg"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didPressShowMeButton(sender: AnyObject) {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.blackColor()
        gallery.pageIndicatorTintColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.whiteColor()

        presentViewController(gallery, animated: true, completion: nil)
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
```


## Author

Justin Vallely, jvallely@inspirato.com

## License

SwiftPhotoGallery is available under the GNU General Public License. See the LICENSE file for more info.
