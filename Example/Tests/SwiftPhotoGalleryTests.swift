import UIKit
import XCTest
import SwiftPhotoGallery
import Nimble

class SwiftPhotoGalleryTests: XCTestCase {

    var testGallery:SwiftPhotoGallery!
    var testHelper:SwiftPhotoGalleryTestHelper!

    override func setUp() {
        super.setUp()

        println("Did Set UP")

        testHelper = SwiftPhotoGalleryTestHelper()
        testGallery = SwiftPhotoGallery(delegate: testHelper, dataSource: testHelper)
    }

    override func tearDown() {

        testGallery = nil
        testHelper = nil

        super.tearDown()
    }
    
    func testProgramaticInitialization() {
        testGallery.viewDidLoad()

        expect(self.testGallery.delegate).toNot(beNil())
        expect(self.testGallery.delegate).to(beIdenticalTo(testHelper))

        expect(self.testGallery.dataSource).toNot(beNil())
        expect(self.testGallery.dataSource).to(beIdenticalTo(testHelper))

        expect(self.testGallery.currentPage).to(equal(0))
    }

    func testNumberOfImagesDataSourceCalled() {
        testGallery.viewDidLoad()

        expect(self.testGallery.numberOfImages).to(equal(6))
        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(beGreaterThan(0))
    }

    func testFirstImagesLoadedAfterInitialization() {
        testGallery.viewDidLoad()

        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        testGallery.imageCollectionView.reloadItemsAtIndexPaths([indexPath])

        expect(self.testHelper.timesAskedForImageInGallery[0]).to(beGreaterThan(0))
        expect(self.testHelper.timesAskedForImageInGallery[1]).to(beGreaterThan(0))
    }

    func testSetDataSourceReloadsImages() {
        let newDataSource = SwiftPhotoGalleryTestHelper()

        expect(newDataSource.timesAskedForNumberOfImagesInGallery).to(equal(0))

        testGallery.dataSource = newDataSource

        testGallery.viewDidLoad()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        testGallery.imageCollectionView.reloadItemsAtIndexPaths([indexPath])

        expect(newDataSource.timesAskedForNumberOfImagesInGallery).to(beGreaterThan(0))

    }

    func testSetSameDataSourceDoesntReload() {
        testGallery.viewDidLoad()

        let timesAskedForNumberOfImagesInGallery = testHelper.timesAskedForNumberOfImagesInGallery

        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(equal(2))

        testGallery.dataSource = testHelper

        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(equal(timesAskedForNumberOfImagesInGallery))

    }

    func testTapCallsDelegateMethod() {

        let singleTap = UITapGestureRecognizer()

        testGallery.handleSingleTap(singleTap)

        expect(self.testHelper.didTellDelegateTapToClose).to(equal(true))
    }
}

class SwiftPhotoGalleryTestHelper: SwiftPhotoGalleryDelegate, SwiftPhotoGalleryDataSource {

    var timesAskedForNumberOfImagesInGallery:Int = 0
    var timesAskedForImageInGallery:[Int:Int] = [:]
    var didTellDelegateTapToClose:Bool = false

    @objc func numberOfImagesInGallery(gallery:SwiftPhotoGallery) -> Int {
        timesAskedForNumberOfImagesInGallery += 1

        return 6
    }

    @objc func imageInGallery(gallery:SwiftPhotoGallery, forIndex:Int) -> UIImage? {
        if let timesAsked = timesAskedForImageInGallery[forIndex] {
            timesAskedForImageInGallery[forIndex] = timesAsked + 1
        } else {
            timesAskedForImageInGallery[forIndex] = 1
        }

        let imageNames = ["image1.jpeg", "image2.jpeg", "image3.jpeg", "image4.jpeg", "image5.jpeg", "image6.jpeg"]

        return UIImage(named: imageNames[forIndex])
    }

    @objc func galleryDidTapToClose(gallery:SwiftPhotoGallery) {
        didTellDelegateTapToClose = true
    }
}
