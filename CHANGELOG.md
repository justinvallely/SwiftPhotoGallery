## Master

## 3.4.1 (2019-05-14)

##### Enhancements

* Adds support for Swift 5.0
* Removes Nimble dependency


## 3.3.1 (2017-12-21)

##### Enhancements

* Changes license from GNU to Apache 2.0 (Big thanks to chrisballinger)

##### Bug Fixes

* Fixes content inset adjustment in the example project. This will not affect your projects.


## 3.3.0 (2017-12-01)

##### Enhancements

* Adds support for Swift 4.0


## 3.2.2 (2017-10-26)

##### Bug Fixes

* Fixes bug when rotation occurs on first image and content is offset, or header display causing last page to be scrolled to during that rotation
* Fixes issue for isViewFirstAppearing not being called in certain conditions
* Improves accuracy and efficiency of revolving carousel when header or footer is reached
* Implements fix to prevent infinite scrolling when only one image is present
* Fixes unit tests


## 3.2.1 (2017-10-19)

##### Bug Fixes

* Fixes issue with loading the first image when a page isn't specified in the presentation completion block
* Fixes unit tests


## 3.2.0 (2017-10-18)

##### Enhancements

* DROPS SUPPORT FOR IOS 8
* Adds revolving gallery carousel. Swipe through last image to get to the first image. (enabled by default)
* Opens up imageView and scrollView access level
* Updates Nimble to 7.0.2 for unit tests on the example project.
* Updates README.md


## 3.1.3 (2017-08-04)

##### Bug Fixes

* cancels swipe to close when dismissing with custom presentation style


## 3.1.2 (2017-08-04)

##### Enhancements

* Example project: Converted to a more common collection view
* Example project: adds presenting and dismissing animators using UIPresentationController and UIViewControllerAnimatedTransitioning
* General code cleanup
* Updates README.md

##### Bug Fixes

* Fixes image flash when loading gallery to a specific page


## 3.1.1 (2017-08-01)

##### Enhancements

* Changes access level of collection view cell's imageView to public


## 3.1.0 (2017-01-25)

##### Enhancements

* Adds support for tvOS
* Adds Twitter-style swipe to dismiss (can be disabled)
* Adds public access to hide/show the status bar


## 3.0.1 (2016-11-14)

##### Bug Fixes

* Fixes flicker on second image
* Fixes images not being sized properly after rotation


## 3.0.0 (2016-10-06)

##### Enhancements

* Adds support for Swift 3.0 and Xcode 8


## 2.0.6 (2016-09-12)

##### Enhancements

* Adds support for Swift 2.3 and Xcode 8


## 2.0.5 (2016-07-20)

##### Enhancements

* Adds the ability to hide the page control at any time.
* More robust calculation for currentPage.

##### Bug Fixes

* Fix for pages jumping by 2 on the first swipe when presenting a gallery.


## 2.0.4 (2016-05-02)

##### Bug Fixes

* Fix for page indicator not updating. This was broken in 2.0.2.


## 2.0.3 (2016-04-29)

##### Enhancements

* Adds this sweet change log. This of course, is a non-breaking change. You're welcome.


## 2.0.2 (2016-04-29)

##### Enhancements

* Updates syntax to Swift 2.2.
* Adds ability to customize the page control colors.
* Reduced overall framework size.

##### Bug Fixes

* Updates to Nimble for broken tests.
* General code cleanup.
* Updates example code to use the latest version of SwiftPhotoGallery. Because, why wouldn't we?


## 2.0.0 (2015-11-05)

##### Enhancements

* Updates syntax to Swift 2.0 


## 1.0.0 (2015-09-10)

##### Enhancements

* Everything is shiny.  

##### Bug Fixes

* Initial release. This is perfect. I'm sure there won't be any bugs.
