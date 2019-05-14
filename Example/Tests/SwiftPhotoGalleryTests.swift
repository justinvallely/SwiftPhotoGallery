import UIKit
import XCTest
import SwiftPhotoGallery
import Nimble

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
        
        expect(self.testGallery.delegate).toNot(beNil())
        expect(self.testGallery.delegate) === testHelper

        expect(self.testGallery.dataSource).toNot(beNil())
        expect(self.testGallery.dataSource) === testHelper

        expect(self.testGallery.currentPage).to(equal(0))
    }

    func testNumberOfImagesDataSourceCalled() {
        testGallery.viewDidLoad()

        expect(self.testGallery.numberOfImages).to(equal(3))
        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(beGreaterThan(0))
    }

    func testFirstImagesLoadedAfterInitialization() {
        testGallery.viewDidLoad()
        testGallery.isRevolvingCarouselEnabled = false

        let indexPath = IndexPath(item: 0, section: 0)
        testGallery.imageCollectionView.reloadItems(at: [indexPath])

        expect(self.testHelper.timesAskedForImageInGallery[0]).to(beGreaterThan(0))
        expect(self.testHelper.timesAskedForImageInGallery[1]).to(beGreaterThan(0))
    }

    func testSetDataSourceReloadsImages() {
        let newDataSource = SwiftPhotoGalleryTestHelper()

        expect(newDataSource.timesAskedForNumberOfImagesInGallery).to(equal(0))

        testGallery.dataSource = newDataSource

        testGallery.viewDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        testGallery.imageCollectionView.reloadItems(at: [indexPath])

        expect(newDataSource.timesAskedForNumberOfImagesInGallery).to(beGreaterThan(0))

    }

    func testSetSameDataSourceDoesntReload() {
        testGallery.viewDidLoad()

        let timesAskedForNumberOfImagesInGallery = testHelper.timesAskedForNumberOfImagesInGallery

        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(equal(4))

        testGallery.dataSource = testHelper

        expect(self.testHelper.timesAskedForNumberOfImagesInGallery).to(equal(timesAskedForNumberOfImagesInGallery))

    }

    func testTapCallsDelegateMethod() {

        let singleTap = UITapGestureRecognizer()

        testGallery.singleTapAction(recognizer: singleTap)

        expect(self.testHelper.didTellDelegateTapToClose).to(equal(true))
    }

    func testSetCurrentPage() {

        let helperCollectionView: HelperCollectionView = HelperCollectionView(frame: CGRect(x: 10, y: 10, width: 100, height: 100), collectionViewLayout: UICollectionViewFlowLayout())

        testGallery.imageCollectionView = helperCollectionView
        helperCollectionView.delegate = testGallery
        helperCollectionView.dataSource = testGallery

        testGallery.currentPage = 3

        expect(helperCollectionView.didScroll).to(equal(true))

    }

    func testReloadWithoutParameters() {
        let helperCollectionView: HelperCollectionView = HelperCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        testGallery.imageCollectionView = helperCollectionView
        helperCollectionView.delegate = testGallery
        helperCollectionView.dataSource = testGallery

        helperCollectionView.reloadDataCalled = false

        testGallery.reload()

        expect(helperCollectionView.reloadDataCalled).to(beTrue())
    }

    func testReloadWithParameters() {
        let helperCollectionView: HelperCollectionView = HelperCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        testGallery.imageCollectionView = helperCollectionView
        helperCollectionView.delegate = testGallery
        helperCollectionView.dataSource = testGallery

        helperCollectionView.reloadDataCalled = false
        helperCollectionView.indexesOfReloadedItems = []

        testGallery.reload(imageIndexes: 1, 2, 3)

        expect(helperCollectionView.reloadDataCalled).to(beFalse())
        expect(helperCollectionView.indexesOfReloadedItems).to(contain(1, 2, 3))
    }
    
    func testSetBackgroundColor() {

        expect(self.testGallery.backgroundColor).to(equal(UIColor.black))

        testGallery.backgroundColor = UIColor.orange

        expect(self.testGallery.backgroundColor).to(equal(UIColor.orange))
        expect(self.testGallery.view.backgroundColor).to(equal(self.testGallery.backgroundColor))
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
