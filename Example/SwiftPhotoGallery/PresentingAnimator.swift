//
//  PresentingAnimator.swift
//  Inspirato
//
//  Created by Justin Vallely on 6/9/17.
//  Copyright © 2017 Inspirato. All rights reserved.
//

import Foundation
import UIKit


class PresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let indexPath: IndexPath
    private let originFrame: CGRect
    private let duration: TimeInterval = 0.5

    init(pageIndex: Int, originFrame: CGRect) {
        self.indexPath = IndexPath(item: pageIndex, section: 0)
        self.originFrame = originFrame
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toView = transitionContext.view(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) as? MainCollectionViewController,
            let fromView = fromVC.collectionView?.cellForItem(at: indexPath) as? MainCollectionViewCell
            else {
                transitionContext.completeTransition(true)
                return
        }

        let finalFrame = toView.frame

        let viewToAnimate = UIImageView(frame: originFrame)
        viewToAnimate.image = fromView.imageView.image
        viewToAnimate.contentMode = .scaleAspectFill
        viewToAnimate.clipsToBounds = true
        fromView.imageView.isHidden = true

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(viewToAnimate)

        toView.isHidden = true

        // Determine the final image height based on final frame width and image aspect ratio
        let imageAspectRatio = viewToAnimate.image!.size.width / viewToAnimate.image!.size.height
        let finalImageheight = finalFrame.width / imageAspectRatio

        // Animate size and position
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.frame.size.width = finalFrame.width
            viewToAnimate.frame.size.height = finalImageheight
            viewToAnimate.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion:{ _ in
            toView.isHidden = false
            fromView.imageView.isHidden = false
            viewToAnimate.removeFromSuperview()
            transitionContext.completeTransition(true)
        })

    }
}
