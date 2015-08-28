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

        expect(self.testHelper.timesAskedForImageInGallery[0]).to(beGreaterThan(0))
        expect(self.testHelper.timesAskedForImageInGallery[1]).to(beGreaterThan(0))
    }

    func testSetCurrentPage() {

        let currentPage = testGallery.currentPage
        let currentOffset = testGallery.collectionView?.contentOffset.x ?? 0
        let currentTimesAsked = testHelper.timesAskedForImageInGallery[3] ?? 0

        expect(currentPage).to(equal(0))
        expect(currentTimesAsked).to(equal(0))

        testGallery.currentPage = 3

        expect(self.testGallery.currentPage).to(equal(3))
        expect(self.testHelper.timesAskedForImageInGallery[3]).to(beGreaterThan(currentTimesAsked))
        expect(self.testGallery.collectionView?.contentOffset.x ?? 0).to(beGreaterThan(currentOffset))
    }

    func testSetDataSourceReloadsImages() {

        let newDataSource = SwiftPhotoGalleryTestHelper()

        expect(newDataSource.timesAskedForNumberOfImagesInGallery).to(equal(0))

        testGallery.dataSource = newDataSource

        expect(newDataSource.timesAskedForNumberOfImagesInGallery).to(beGreaterThan(0))

    }

    func testSetSameDataSourceDoesntReload() {

        let timesAskedForNumberOfImagesInGallery = testHelper.timesAskedForNumberOfImagesInGallery

        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(equal(1))

        testGallery.dataSource = testHelper

        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(equal(timesAskedForNumberOfImagesInGallery))

    }

    func testTapCallsDelegateMethod() {

        testGallery.handleSingleTap()

        expect(self.testHelper.didTellDelegateTapToClose).to(equal(true))
    }

    func testDoubleTapZoomsInAndOut() {

        let currentZoomScale = testGallery.collectionView?.zoomScale

        testGallery.handleDoubleTap()

        expect(self.testGallery.collectionView?.zoomScale).to(beGreaterThan(currentZoomScale))

        testGallery.handleDoubleTap()

        expect(self.testGallery.collectionView?.zoomScale).to(equal(currentZoomScale))

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

        let imageNames = ["image.png", "pano.jpg", "slide1@3x.png", "slide2@3x.png", "slide3@3x.png", "slide4@3x.png"]

        return UIImage(named: imageNames[forIndex])
    }

    @objc func galleryDidTapToClose(gallery:SwiftPhotoGallery) {
        didTellDelegateTapToClose = true
    }

}