//
//  SwiftPhotoGalleryCell.swift
//  Pods
//
//  Created by Justin Vallely on 9/10/15.
//
//

public class SwiftPhotoGalleryCell: UICollectionViewCell, UIScrollViewDelegate {

    var image:UIImage? {
        didSet {
            configureForNewImage()
        }
    }

    private var scrollView: UIScrollView
    private let imageView: UIImageView

    override init(frame: CGRect) {

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView = UIScrollView(frame: frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)
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

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func doubleTapAction(recognizer: UITapGestureRecognizer) {

        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    internal func configureForNewImage() {
        imageView.image = image
        imageView.sizeToFit()
        imageView.alpha = 0.0

        setZoomScale()
        scrollViewDidZoom(scrollView)
        
        UIView.animateWithDuration(0.5) {
            self.imageView.alpha = 1.0
        }
    }
    

    // MARK: UIScrollViewDelegate Methods

    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(scrollView: UIScrollView) {

        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        if verticalPadding >= 0 {
            // Center the image on screen
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        } else {
            // Limit the image panning to the screen bounds
            scrollView.contentSize = imageViewSize
        }

    }

    // MARK: Private Methods

    private func setupGestureRecognizer() {

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(SwiftPhotoGalleryCell.doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }

    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
}