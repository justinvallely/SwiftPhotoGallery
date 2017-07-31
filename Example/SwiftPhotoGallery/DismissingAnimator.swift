//
//  DismissingAnimator.swift
//  Inspirato
//
//  Created by Justin Vallely on 6/12/17.
//  Copyright © 2017 Inspirato. All rights reserved.
//

import Foundation
import UIKit
import SwiftPhotoGallery

class DismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private var pageIndex = 0
    private let duration: TimeInterval = 0.5

    init(pageIndex: Int) {
        super.init()
        self.pageIndex = pageIndex
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let indexPath = IndexPath(item: pageIndex, section: 0)

        guard let toVC = transitionContext.viewController(forKey: .to) as? ViewController,
            let pageContentVC = toVC.pageViewController.viewControllers?[0] as? PageContentViewController,
            let fromVC = transitionContext.viewController(forKey: .from) as? SwiftPhotoGallery,
            let cell = fromVC.imageCollectionView.cellForItem(at: indexPath) as? SwiftPhotoGalleryCell
            else {
                transitionContext.completeTransition(true)
                return
        }

        let containerView = transitionContext.containerView

        // Determine our original and final frames
        let size = cell.imageView.frame.size
        let convertedRect = cell.imageView.convert(cell.imageView.bounds, to: containerView)
        let originFrame = CGRect(origin: convertedRect.origin, size: size)
        let finalFrame = pageContentVC.imageView.frame

        let viewToAnimate = UIImageView(frame: originFrame)
        viewToAnimate.center = CGPoint(x: convertedRect.midX, y: convertedRect.midY)
        viewToAnimate.image = cell.imageView.image
        viewToAnimate.contentMode = .scaleAspectFill
        viewToAnimate.clipsToBounds = false

        containerView.addSubview(viewToAnimate)

        // Determine the new image size
        let xScaleFactor = finalFrame.width / originFrame.width
        let aspectRatio = cell.imageView.frame.width / cell.imageView.frame.height
        let newheight = finalFrame.width / aspectRatio
        let yScaleFactor = newheight / originFrame.height

        pageContentVC.imageView.isHidden = true
        fromVC.view.isHidden = true

        // Animate size and position
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            viewToAnimate.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion:{ _ in
            pageContentVC.imageView.isHidden = false
            viewToAnimate.removeFromSuperview()
            transitionContext.completeTransition(true)
        })

    }
}
