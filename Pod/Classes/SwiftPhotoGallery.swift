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


public class SwiftPhotoGallery: UIViewController, UICollectionViewDataSource, UIScrollViewDelegate {

    // MARK: Public Interface

    @IBOutlet public var dataSource:SwiftPhotoGalleryDataSource?
    @IBOutlet public var delegate:SwiftPhotoGalleryDelegate?

    public private(set) var collectionView: UICollectionView?
    public private(set) var numberOfImages: Int = 0
    public var currentPage: Int = 0


    public init(delegate: SwiftPhotoGalleryDelegate, dataSource: SwiftPhotoGalleryDataSource) {
        super.init(nibName: nil, bundle: nil)

        self.dataSource = dataSource
        self.delegate = delegate
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //loadview
    //self.view = UIView()

    override public func viewDidLoad() {
        super.viewDidLoad()

        var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        collectionView = UICollectionView(frame: CGRectMake(10, 10, 300, 400), collectionViewLayout: flowLayout)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        //collectionView?.delegate = self.delegate
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.cyanColor()


        imageView = UIImageView(image: dataSource?.imageInGallery(self, forIndex: currentPage))

        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.redColor()
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        //scrollView.contentOffset = CGPoint(x: imageView.bounds.size.width/2, y: imageView.bounds.size.height/2)

        scrollView.addSubview(imageView)
        collectionView!.addSubview(scrollView)
        self.view.addSubview(collectionView!)
        //view.addSubview(scrollView)

        scrollView.delegate = self
    }

    public func handleSingleTap(sender: AnyObject? = nil) {
        delegate?.galleryDidTapToClose(self)
    }

    public func handleDoubleTap(sender: AnyObject? = nil) {

    }


    // MARK: Private Methods / Properties

    // When you need an image, you'll ask your delegate like
    // let imageForPage = self.dataSource.imageInGallery(self, currentPage)

    var scrollView: UIScrollView!
    var imageView: UIImageView!

    

    // MARK: UICollectionViewDataSource Methods

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfImagesInGallery(self) ?? 0
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //return UICollectionViewCell(frame: CGRectZero)
        var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(50, 50)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
        //top,left,bottom,right
    }

}
/*
class swiftPhotoGalleryCollectionView: UICollectionView {

}

class swiftPhotoGalleryCell: UICollectionViewCell {

}

class swiftPhotoGalleryLayout: UICollectionViewLayout {

}
*/




