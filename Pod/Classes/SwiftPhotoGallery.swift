//
//  SwiftPhotoGallery.swift
//  Pods
//
//  Created by Justin Vallely on 8/25/15.
//
//

import Foundation
import UIKit

@objc public protocol SwiftPhotoGalleryDataSource {
    func numberOfImagesInGallery(gallery:SwiftPhotoGallery) -> Int
    func imageInGallery(gallery:SwiftPhotoGallery, forIndex:Int) -> UIImage?
}

@objc public protocol SwiftPhotoGalleryDelegate {
    func galleryDidTapToClose(gallery:SwiftPhotoGallery)
}

    // MARK: ------ SwiftPhotoGallery ------

public class SwiftPhotoGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: Public Interface

    @IBOutlet public var dataSource:SwiftPhotoGalleryDataSource?
    @IBOutlet public var delegate:SwiftPhotoGalleryDelegate?

    public private(set) var imageCollectionView: UICollectionView!

    public var numberOfImages: Int = 0

    public var currentPage: Int {
        get {
            return Int((imageCollectionView.contentOffset.x / imageCollectionView.contentSize.width) * CGFloat(numberOfImages))
        }
    }

    private var pageBeforeRotation: Int = 0
    private var currentIndexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    private var currentCell: SwiftPhotoGalleryCell = SwiftPhotoGalleryCell()
    private var viewBoundsSize: CGSize = CGSize() {
        didSet {
            println("viewBoundsSize: \(viewBoundsSize)")
        }
    }

    var pageControl:UIPageControl!

    var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    public init(delegate: SwiftPhotoGalleryDelegate, dataSource: SwiftPhotoGalleryDataSource) {
        super.init(nibName: nil, bundle: nil)

        self.dataSource = dataSource
        self.delegate = delegate
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    override public func loadView() {
//        super.loadView()
//
//        //view = UIView(frame: view.bounds)
//    }



//    override public func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        pageBeforeRotation = currentPage
//
//        let nextPageIndexPath = NSIndexPath(forItem: pageBeforeRotation + 1, inSection: 0)
//        let thisPageIndexPath = NSIndexPath(forItem: pageBeforeRotation, inSection: 0)
//        let previousPageIndexPath = NSIndexPath(forItem: pageBeforeRotation - 1, inSection: 0)
//        println("nextPageIndexPath: \(nextPageIndexPath)")
//        println("thisPageIndexPath: \(thisPageIndexPath)")
//        println("previousPageIndexPath: \(previousPageIndexPath)")
//
//        println("pageBeforeRotation: \(pageBeforeRotation)")
//
//        //flowLayout.itemSize = view.bounds.size
//
//        //flowLayout.invalidateLayout()
//        if let currentCell = self.imageCollectionView.cellForItemAtIndexPath(nextPageIndexPath) as? SwiftPhotoGalleryCell {
//            currentCell.configureForNewImage()
//        }
//
//    }

//    override public func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        pageBeforeRotation = currentPage
//
//        flowLayout.itemSize = CGSize(width: imageCollectionView.frame.height, height: imageCollectionView.frame.width)
//        flowLayout.invalidateLayout()
//
//        let currentCell = imageCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: currentPage, inSection: 0))
//        let centerOfCell = currentCell?.center ?? CGPointZero
//        let centerInSuperViewCoord = imageCollectionView?.superview?.convertPoint(centerOfCell, fromView: imageCollectionView!)
//        imageCollectionView.center = centerInSuperViewCoord ?? imageCollectionView.center
//
////        view.addSubview(currentCell!)
////
////        var imageCollectionViewConstraints: [NSLayoutConstraint] = []
////        imageCollectionViewConstraints.append(NSLayoutConstraint(item: currentCell!, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
////        imageCollectionViewConstraints.append(NSLayoutConstraint(item: currentCell!, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
////        imageCollectionViewConstraints.append(NSLayoutConstraint(item: currentCell!, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
////        imageCollectionViewConstraints.append(NSLayoutConstraint(item: currentCell!, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
////
////        view.addConstraints(imageCollectionViewConstraints)
//
//    }

//    override public func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        //imageCollectionView.reloadData()
//        imageCollectionView.performBatchUpdates(nil, completion: nil)
//        flowLayout.itemSize = imageCollectionView.frame.size
//        //let desiredIndexPath = NSIndexPath(forItem: pageBeforeRotation, inSection: 0)
//        //imageCollectionView.reloadItemsAtIndexPaths([desiredIndexPath])
//
////        currentCell!.removeFromSuperview()
//
////        let desiredIndexPath = NSIndexPath(forItem: pageBeforeRotation, inSection: 0)
////        if let currentCell = imageCollectionView.cellForItemAtIndexPath(desiredIndexPath) as? SwiftPhotoGalleryCell {
////            currentCell.configureForNewImage()
////        }
//
//
////        flowLayout.finalizeCollectionViewUpdates()
//        //imageCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: pageBeforeRotation, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
//    }

//    override public func viewDidLayoutSubviews() {
//        let desiredIndexPath = NSIndexPath(forItem: currentPage, inSection: 0)
//        imageCollectionView.reloadItemsAtIndexPaths([desiredIndexPath])

//        if let currentCell = imageCollectionView.cellForItemAtIndexPath(desiredIndexPath) as? SwiftPhotoGalleryCell {
//            currentCell.configureForNewImage()
//        }

//        if pageBeforeRotation > 0 {
//            imageCollectionView.scrollToItemAtIndexPath(desiredIndexPath, atScrollPosition: .CenteredHorizontally, animated: true)
//            imageCollectionView.reloadItemsAtIndexPaths([desiredIndexPath])
//        }

//    }


    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        // Calculate current page to update the content offset to the correct position when the orientation changes
        // I take a copy of the currentPage variable, as it will be incorrectly calculated once we are in the animateAlongsideTransition block
        // Because the contentSize will already be changed to reflect the new orientation
        let theCurrentPage = Int(currentPage)

        coordinator.animateAlongsideTransition({ (context) -> Void in

            let contentOffSet:CGPoint
            contentOffSet = CGPoint(x: Int(self.imageCollectionView.bounds.size.width) * theCurrentPage, y: 0)

            self.imageCollectionView.contentOffset = contentOffSet

            }, completion: { (context) -> Void in
                //let desiredIndexPath = NSIndexPath(forItem: self.currentPage, inSection: 0)
                //self.imageCollectionView.reloadItemsAtIndexPaths([desiredIndexPath])
        })
        
        flowLayout.invalidateLayout()
        
    }


    public func collectionView(imageCollectionView: UICollectionView, layout flowLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return imageCollectionView.bounds.size
    }

    
    // MARK: Lifecycle methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor.grayColor()

        //viewBoundsSize = view.bounds.size

        setupCollectionView()
        setupPageControl()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: Private Methods / Properties

    private func setupCollectionView() {
        // Set up flow layout
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        //flowLayout.itemSize = viewBoundsSize

        imageCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        imageCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)

        numberOfImages = collectionView(imageCollectionView, numberOfItemsInSection: 0)

        // Set up collection view
        imageCollectionView.registerClass(SwiftPhotoGalleryCell.self, forCellWithReuseIdentifier: "SwiftPhotoGalleryCell")
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.pagingEnabled = true
        //imageCollectionView.backgroundColor = UIColor.cyanColor()

        // Set up collection view constraints
        var imageCollectionViewConstraints: [NSLayoutConstraint] = []
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))

        view.addSubview(imageCollectionView)
        view.addConstraints(imageCollectionViewConstraints)
    }

    private func setupPageControl() {

        pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)

        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()

        pageControl.hidden = false
        view.addSubview(pageControl)

        let centerXConstraint = NSLayoutConstraint(item: pageControl,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0)

        let bottomConstraint = NSLayoutConstraint(item: pageControl,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -5)

        view.addConstraints([centerXConstraint, bottomConstraint])
        
    }

    func getImage(currentPage: Int) -> UIImage {
        var imageForPage = dataSource?.imageInGallery(self, forIndex: currentPage)
        return imageForPage!
    }


    // MARK: UICollectionViewDataSource Methods
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(imageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfImagesInGallery(self) ?? 0
    }

    public func collectionView(imageCollectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: SwiftPhotoGalleryCell = imageCollectionView.dequeueReusableCellWithReuseIdentifier("SwiftPhotoGalleryCell", forIndexPath: indexPath) as! SwiftPhotoGalleryCell
        //cell.setTranslatesAutoresizingMaskIntoConstraints(false)

        cell.image = getImage(indexPath.row)

        return cell
    }


    // MARK: UICollectionViewDelegate Methods
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //let visibleIndexes = imageCollectionView.indexPathsForVisibleItems()
        
        //currentPage = visibleIndexes.first?.item ?? 0

        // If the scroll animation ended, update the page control to reflect the current page we are on
        pageControl.currentPage = currentPage
        println("currentPage: \(currentPage)")

    }
}

/*******************************************************************************************************************************/

    // MARK: ------ SwiftPhotoGalleryCell ------

public class SwiftPhotoGalleryCell: UICollectionViewCell, UIScrollViewDelegate {

    var image:UIImage? {
        didSet {
            configureForNewImage()
        }
    }

    private let scrollView: UIScrollView
    private let imageView: UIImageView
    //static let colors = [UIColor.yellowColor(), UIColor.blueColor(), UIColor.redColor(), UIColor.brownColor(), UIColor.orangeColor()]
    static var cellCount: Int = 0

    override init(frame: CGRect) {

        imageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView = UIScrollView(frame: frame)
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(frame: frame)

        //scrollView.backgroundColor = SwiftPhotoGalleryCell.colors[SwiftPhotoGalleryCell.cellCount % SwiftPhotoGalleryCell.colors.count]
        SwiftPhotoGalleryCell.cellCount++

        var scrollViewConstraints: [NSLayoutConstraint] = []
        var imageViewConstraints: [NSLayoutConstraint] = []

        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .Leading, multiplier: 1, constant: 0))
        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 0))
        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1, constant: 0))
        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))

        contentView.addSubview(scrollView)
        contentView.addConstraints(scrollViewConstraints)

        imageViewConstraints.append(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .Leading, multiplier: 1, constant: 0))
        imageViewConstraints.append(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0))
        imageViewConstraints.append(NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: scrollView, attribute: .Trailing, multiplier: 1, constant: 0))
        imageViewConstraints.append(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1, constant: 0))

        scrollView.addSubview(imageView)
        scrollView.addConstraints(imageViewConstraints)

        scrollView.delegate = self

        setupGestureRecognizer()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureForNewImage() {
        imageView.image = image
        imageView.sizeToFit()
        setZoomScale()
        scrollViewDidZoom(scrollView)
    }

    // MARK: Zoom Handlers

    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

//    override func viewWillLayoutSubviews() {
//        setZoomScale()
//    }

    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    private func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }

    // MARK: Gesture Handlers

    private func setupGestureRecognizer() {

        let tripleTap = UITapGestureRecognizer(target: self, action: "handleTripleTap:")
        tripleTap.numberOfTapsRequired = 3
        scrollView.addGestureRecognizer(tripleTap)

        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        let singleTap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        singleTap.numberOfTapsRequired = 1
        singleTap.requireGestureRecognizerToFail(doubleTap)
        scrollView.addGestureRecognizer(singleTap)

    }

    public func handleSingleTap(recognizer: UITapGestureRecognizer) {
        //delegate?.galleryDidTapToClose(self)
        println("SINGLE tap")
    }

    public func handleDoubleTap(recognizer: UITapGestureRecognizer) {

        println("DOUBLE tap")
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    public func handleTripleTap(recognizer: UITapGestureRecognizer) {
        println("TRIPLE tap")
    }
}





