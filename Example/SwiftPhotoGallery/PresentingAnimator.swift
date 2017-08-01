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

    private let duration: TimeInterval = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toView = transitionContext.view(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) as? MainViewController,
            let fromView = fromVC.pageViewController.viewControllers?[0] as? PageContentViewController
            else {
                transitionContext.completeTransition(true)
                return
        }

        let originFrame = fromView.imageView.frame
        let finalFrame = toView.frame

        let viewToAnimate = UIImageView(frame: originFrame)
        viewToAnimate.image = fromView.imageView.image
        viewToAnimate.contentMode = .scaleAspectFill
        viewToAnimate.clipsToBounds = false
        fromView.imageView.isHidden = true

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(viewToAnimate)

        toView.isHidden = true

        // Determine the new image size
        let xScaleFactor = finalFrame.width / originFrame.width
        let aspectRatio = originFrame.width / originFrame.height
        let newheight = finalFrame.width / aspectRatio
        let yScaleFactor = newheight / originFrame.height

        // Animate size and position
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            viewToAnimate.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion:{ _ in
            toView.isHidden = false
            fromView.imageView.isHidden = false
            viewToAnimate.removeFromSuperview()
            transitionContext.completeTransition(true)
        })

    }
}
