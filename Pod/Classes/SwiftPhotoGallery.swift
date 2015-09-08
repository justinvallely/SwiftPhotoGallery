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


public class SwiftPhotoGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: Public Interface

    @IBOutlet public var dataSource:SwiftPhotoGalleryDataSource?
    @IBOutlet public var delegate:SwiftPhotoGalleryDelegate?

    public private(set) var imageCollectionView: UICollectionView!

    public var numberOfImages: Int = 0
    public var currentPage: Int = 0
    private var pageBeforeRotation: Int = 0
    private var currentIndexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    private var currentCell: SwiftPhotoGalleryCell = SwiftPhotoGalleryCell()


    var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout();

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

    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

//        pageBeforeRotation = currentPage
        //println("pageBeforeRotation: \(pageBeforeRotation)")
        
        flowLayout.itemSize = view.bounds.size
//        flowLayout.invalidateLayout()
        
    }

    override public func viewDidLayoutSubviews() {
        println("viewDidLayoutSubviews")
        let desiredIndexPath = NSIndexPath(forItem: pageBeforeRotation, inSection: 0)
        
//        if pageBeforeRotation > 0 {
//            imageCollectionView.scrollToItemAtIndexPath(desiredIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
//            imageCollectionView.reloadItemsAtIndexPaths([desiredIndexPath])
//        }

        if let currentCell = imageCollectionView.cellForItemAtIndexPath(desiredIndexPath) as? SwiftPhotoGalleryCell {
            currentCell.configureForNewImage()
        }
    }
    /*---------------*/

    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("viewWillTransitionToSize")
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        pageBeforeRotation = currentPage
        let desiredIndexPath = NSIndexPath(forItem: pageBeforeRotation, inSection: 0)
        println("pageBeforeRotation: \(pageBeforeRotation)")
        if pageBeforeRotation > 0 {
            imageCollectionView.scrollToItemAtIndexPath(desiredIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
            imageCollectionView.reloadItemsAtIndexPaths([desiredIndexPath])
        }
        self.imageCollectionView.performBatchUpdates(nil, completion: nil)
    }
    
//    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return collectionView.bounds.size
//    }
    
    /*---------------*/
    override public func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")

        //view.backgroundColor = UIColor.grayColor()

        // Set up flow layout
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        imageCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        imageCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)

        numberOfImages = collectionView(imageCollectionView, numberOfItemsInSection: 0)

        // Set up collection view
        imageCollectionView.registerClass(SwiftPhotoGalleryCell.self, forCellWithReuseIdentifier: "SwiftPhotoGalleryCell")
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        //imageCollectionView.backgroundColor = UIColor.cyanColor()
        imageCollectionView.pagingEnabled = true

        var imageCollectionViewConstraints: [NSLayoutConstraint] = []
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))

        view.addSubview(imageCollectionView)
        view.addConstraints(imageCollectionViewConstraints)
    }


    // MARK: Private Methods / Properties

    func getImage(currentPage: Int) -> UIImage {
        var imageForPage = dataSource?.imageInGallery(self, forIndex: currentPage)
        return imageForPage!
    }


    // MARK: UICollectionViewDataSource Methods

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
        let visibleIndexes = imageCollectionView.indexPathsForVisibleItems()
        
        currentIndexPath = visibleIndexes.first as! NSIndexPath
        currentPage = visibleIndexes.first?.item ?? 0
        println("currentPage: \(currentPage)")
    }
}

/*******************************************************************************************************************************/

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





