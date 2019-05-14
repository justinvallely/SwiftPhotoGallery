import UIKit
import XCTest
import SwiftPhotoGallery

class SwiftPhotoGalleryTests: XCTestCase {

    var testGallery:SwiftPhotoGallery!
    var testHelper:SwiftPhotoGalleryTestHelper!

    override func setUp() {
        super.setUp()

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
        testGallery.isRevolvingCarouselEnabled = false

        XCTAssert(self.testGallery.delegate != nil)
        XCTAssert(self.testGallery.delegate === testHelper)

        XCTAssert(self.testGallery.dataSource != nil)
        XCTAssert(self.testGallery.dataSource === testHelper)

        XCTAssert(self.testGallery.currentPage == 0)
    }

    func testNumberOfImagesDataSourceCalled() {
        testGallery.viewDidLoad()

        XCTAssert(self.testGallery.numberOfImages == 3)
        XCTAssert(self.testHelper.timesAskedForNumberOfImagesInGallery > 0)
    }

    func testFirstImagesLoadedAfterInitialization() {
        testGallery.viewDidLoad()
        testGallery.isRevolvingCarouselEnabled = false

        let indexPath = IndexPath(item: 0, section: 0)
        testGallery.imageCollectionView.reloadItems(at: [indexPath])

        XCTAssert(self.testHelper.timesAskedForImageInGallery[0]! > 0)
        XCTAssert(self.testHelper.timesAskedForImageInGallery[1]! > 0)
    }

    func testSetDataSourceReloadsImages() {
        let newDataSource = SwiftPhotoGalleryTestHelper()

        XCTAssert(newDataSource.timesAskedForNumberOfImagesInGallery == 0)

        testGallery.dataSource = newDataSource

        testGallery.viewDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        testGallery.imageCollectionView.reloadItems(at: [indexPath])

        XCTAssert(newDataSource.timesAskedForNumberOfImagesInGallery > 0)
    }

    func testSetSameDataSourceDoesntReload() {
        testGallery.viewDidLoad()

        let timesAskedForNumberOfImagesInGallery = testHelper.timesAskedForNumberOfImagesInGallery

        XCTAssert(self.testHelper.timesAskedForNumberOfImagesInGallery == 4)

        testGallery.dataSource = testHelper

        XCTAssert(self.testHelper.timesAskedForNumberOfImagesInGallery == timesAskedForNumberOfImagesInGallery)
    }

    func testTapCallsDelegateMethod() {

        let singleTap = UITapGestureRecognizer()

        testGallery.singleTapAction(recognizer: singleTap)

        XCTAssert(self.testHelper.didTellDelegateTapToClose == true)
    }

    func testSetCurrentPage() {

        let helperCollectionView: HelperCollectionView = HelperCollectionView(frame: CGRect(x: 10, y: 10, width: 100, height: 100), collectionViewLayout: UICollectionViewFlowLayout())

        testGallery.imageCollectionView = helperCollectionView
        helperCollectionView.delegate = testGallery
        helperCollectionView.dataSource = testGallery

        testGallery.currentPage = 3

        XCTAssert(helperCollectionView.didScroll == true)
    }

    func testReloadWithoutParameters() {
        let helperCollectionView: HelperCollectionView = HelperCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        testGallery.imageCollectionView = helperCollectionView
        helperCollectionView.delegate = testGallery
        helperCollectionView.dataSource = testGallery

        helperCollectionView.reloadDataCalled = false

        testGallery.reload()

        XCTAssert(helperCollectionView.reloadDataCalled == true)
    }

    func testReloadWithParameters() {
        let helperCollectionView: HelperCollectionView = HelperCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        testGallery.imageCollectionView = helperCollectionView
        helperCollectionView.delegate = testGallery
        helperCollectionView.dataSource = testGallery

        helperCollectionView.reloadDataCalled = false
        helperCollectionView.indexesOfReloadedItems = []

        testGallery.reload(imageIndexes: 1, 2, 3)

        XCTAssert(helperCollectionView.reloadDataCalled == false)
        XCTAssert(helperCollectionView.indexesOfReloadedItems.contains(1) == true)
        XCTAssert(helperCollectionView.indexesOfReloadedItems.contains(2) == true)
        XCTAssert(helperCollectionView.indexesOfReloadedItems.contains(3) == true)
    }
    
    func testSetBackgroundColor() {

        XCTAssert(self.testGallery.backgroundColor == UIColor.black)

        testGallery.backgroundColor = UIColor.orange

        XCTAssert(self.testGallery.backgroundColor == UIColor.orange)
        XCTAssert(self.testGallery.view.backgroundColor == self.testGallery.backgroundColor)
    }

}

class SwiftPhotoGalleryTestHelper: SwiftPhotoGalleryDelegate, SwiftPhotoGalleryDataSource {

    var timesAskedForNumberOfImagesInGallery:Int = 0
    var timesAskedForImageInGallery:[Int:Int] = [:]
    var didTellDelegateTapToClose:Bool = false

    @objc func numberOfImagesInGallery(gallery:SwiftPhotoGallery) -> Int {
        timesAskedForNumberOfImagesInGallery += 1

        return 3
    }

    @objc func imageInGallery(gallery:SwiftPhotoGallery, forIndex:Int) -> UIImage? {
        if let timesAsked = timesAskedForImageInGallery[forIndex] {
            timesAskedForImageInGallery[forIndex] = timesAsked + 1
        } else {
            timesAskedForImageInGallery[forIndex] = 1
        }

        let imageNames = ["image1.jpeg", "image2.jpeg", "image3.jpeg"]

        return UIImage(named: imageNames[forIndex])
    }

    @objc func galleryDidTapToClose(gallery:SwiftPhotoGallery) {
        didTellDelegateTapToClose = true
    }
}

class HelperCollectionView: UICollectionView {
    var didScroll = false
    var reloadDataCalled = false
    var indexesOfReloadedItems:[Int] = []

    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        didScroll = true
    }

    override func reloadData() {
        reloadDataCalled = true

        super.reloadData()
    }

    override func reloadItems(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            indexesOfReloadedItems.append((indexPath as NSIndexPath).row)
        }

    }

}
