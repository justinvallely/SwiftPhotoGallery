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

public class SwiftPhotoGallery: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet public var dataSource: SwiftPhotoGalleryDataSource?
    @IBOutlet public var delegate: SwiftPhotoGalleryDelegate?

    public var imageCollectionView: UICollectionView!
    public var numberOfImages: Int = 0

    public var backgroundColor: UIColor = UIColor.blackColor()

    public var currentPage: Int {
        set(page) {
            if page <= numberOfImages - 1 {
                imageCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: page, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
            } else {
                imageCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: numberOfImages - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
            }
            scrollViewDidEndDecelerating(imageCollectionView)
        }
        get {
            return Int((imageCollectionView.contentOffset.x / imageCollectionView.contentSize.width) * CGFloat(numberOfImages))
        }
    }

    private var pageBeforeRotation: Int = 0
    private var currentIndexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    private var pageControl:UIPageControl!
    private var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    
    // MARK: Public Interface
    
    public init(delegate: SwiftPhotoGalleryDelegate, dataSource: SwiftPhotoGalleryDataSource) {
        super.init(nibName: nil, bundle: nil)

        self.dataSource = dataSource
        self.delegate = delegate
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func reload(imageIndexes:Int...) {

        if imageIndexes.isEmpty {

            imageCollectionView.reloadData()

        } else {

            var indexPaths: [NSIndexPath] = imageIndexes.map({NSIndexPath(forItem: $0, inSection: 0)})

            imageCollectionView.reloadItemsAtIndexPaths(indexPaths)
        }
    }
    

    // MARK: Lifecycle methods

    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        pageBeforeRotation = currentPage

        flowLayout.itemSize = view.bounds.size
    }

    override public func viewDidLayoutSubviews() {
        let desiredIndexPath = NSIndexPath(forItem: pageBeforeRotation, inSection: 0)

        if pageBeforeRotation > 0 {
            imageCollectionView.scrollToItemAtIndexPath(desiredIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
        }

        imageCollectionView.reloadItemsAtIndexPaths([desiredIndexPath])

        if let currentCell = imageCollectionView.cellForItemAtIndexPath(desiredIndexPath) as? SwiftPhotoGalleryCell {
            currentCell.configureForNewImage()
        }
        
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupPageControl()
        setupGestureRecognizer()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: Rotation Handling

    override public func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }

    override public func shouldAutorotate() -> Bool {
        return true
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

        cell.image = getImage(indexPath.row)

        return cell
    }


    // MARK: UICollectionViewDelegate Methods

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {

        pageControl.alpha = 1.0
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        // If the scroll animation ended, update the page control to reflect the current page we are on
        pageControl?.currentPage = currentPage

        UIView.animateWithDuration(1.0, delay: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.pageControl?.alpha = 0.0
        }, completion: nil)
    }


    // MARK: UIGestureRecognizerDelegate Methods

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer is UITapGestureRecognizer &&
            gestureRecognizer is UITapGestureRecognizer &&
            otherGestureRecognizer.view is SwiftPhotoGalleryCell &&
            gestureRecognizer.view == imageCollectionView
    }


    // MARK: Gesture Handlers

    private func setupGestureRecognizer() {

        let singleTap = UITapGestureRecognizer(target: self, action: "singleTapAction:")
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        imageCollectionView.addGestureRecognizer(singleTap)
    }

    public func singleTapAction(recognizer: UITapGestureRecognizer) {
        delegate?.galleryDidTapToClose(self)
    }


    // MARK: Private Methods / Properties

    private var bottomConstraint: NSLayoutConstraint?
    private var centerXConstraint: NSLayoutConstraint?

    private func setupCollectionView() {
        // Set up flow layout
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        // Set up collection view
        imageCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        imageCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageCollectionView.registerClass(SwiftPhotoGalleryCell.self, forCellWithReuseIdentifier: "SwiftPhotoGalleryCell")
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.pagingEnabled = true
        imageCollectionView.backgroundColor = backgroundColor

        // Set up collection view constraints
        var imageCollectionViewConstraints: [NSLayoutConstraint] = []
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: imageCollectionView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))

        view.addSubview(imageCollectionView)
        view.addConstraints(imageCollectionViewConstraints)

        numberOfImages = collectionView(imageCollectionView, numberOfItemsInSection: 0)

        imageCollectionView.contentSize = CGSize(width: 1000.0, height: 1.0)
    }

    private func setupPageControl() {

        pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)

        pageControl.numberOfPages = numberOfImages
        pageControl.currentPage = 0

        let inspiratoBlue: UIColor = UIColor(red: 0.0, green: 0.66, blue: 0.875, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = inspiratoBlue

        //let inspiratoBlueDim: UIColor = UIColor(red: 0.0, green: 0.66, blue: 0.875, alpha: 0.25)
        //pageControl.pageIndicatorTintColor = inspiratoBlueDim

        pageControl.alpha = 1
        pageControl.hidden = false

        view.addSubview(pageControl)

        centerXConstraint = NSLayoutConstraint(item: pageControl,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0)

        bottomConstraint = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: pageControl,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 15)

        view.addConstraints([centerXConstraint!, bottomConstraint!])

    }

    private func getImage(currentPage: Int) -> UIImage {
        var imageForPage = dataSource?.imageInGallery(self, forIndex: currentPage)
        return imageForPage!
    }
    

}

