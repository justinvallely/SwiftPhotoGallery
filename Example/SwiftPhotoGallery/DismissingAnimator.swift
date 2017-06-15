//
//  DismissingAnimator.swift
//  Inspirato
//
//  Created by Justin Vallely on 6/12/17.
//  Copyright © 2017 Inspirato. All rights reserved.
//

import Foundation
import pop

class DismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if let toView = transitionContext.viewController(forKey: .to)?.view, let fromView = transitionContext.viewController(forKey: .from)?.view {
            toView.tintAdjustmentMode = .normal
            toView.isUserInteractionEnabled = true

            var dimmingView: UIView?

            for subview in transitionContext.containerView.subviews.enumerated() where subview.element.layer.opacity < 1.0 {
                dimmingView = subview.element
                break
            }

            let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)!
            opacityAnimation.toValue = (0.0)

            let offscreenAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)!
            offscreenAnimation.toValue = (-fromView.layer.position.y)
            offscreenAnimation.completionBlock = {(_ anim: POPAnimation?, _ finished: Bool) -> Void in
                transitionContext.completeTransition(true)
            }

            fromView.layer.pop_add(offscreenAnimation, forKey: "offscreenAnimation")
            dimmingView?.layer.pop_add(opacityAnimation, forKey: "opacityAnimation")
        }
    }
}
