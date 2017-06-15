//
//  PresentingAnimator.swift
//  Inspirato
//
//  Created by Justin Vallely on 6/9/17.
//  Copyright © 2017 Inspirato. All rights reserved.
//

import Foundation
import pop

class PresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if let fromView = transitionContext.viewController(forKey: .from)?.view, let toView = transitionContext.viewController(forKey: .to)?.view {
            fromView.tintAdjustmentMode = .dimmed
            fromView.isUserInteractionEnabled = false

            let dimmingView = UIView(frame: fromView.bounds)
            dimmingView.backgroundColor = UIColor.black
            dimmingView.layer.opacity = 0.0

            let width: CGFloat = UIScreen.main.traitCollection.horizontalSizeClass == .regular ? 335 : transitionContext.containerView.bounds.width - 40

            toView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: CGFloat(364))
            toView.center = CGPoint(x: CGFloat(transitionContext.containerView.center.x), y: CGFloat(transitionContext.containerView.center.y))
            transitionContext.containerView.addSubview(dimmingView)
            transitionContext.containerView.addSubview(toView)

            let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)!
            positionAnimation.toValue = (transitionContext.containerView.center.y)
            positionAnimation.springBounciness = 10
            positionAnimation.completionBlock = {(_ anim: POPAnimation?, _ finished: Bool) -> Void in
                transitionContext.completeTransition(true)
            }

            let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)!
            scaleAnimation.springBounciness = 10
            scaleAnimation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(1.2), y: CGFloat(1.4)))

            let opacityAnimation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)!
            opacityAnimation.toValue = (0.7)

            toView.layer.pop_add(positionAnimation, forKey: "positionAnimation")
            toView.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
            dimmingView.layer.pop_add(opacityAnimation, forKey: "opacityAnimation")
        }
    }
}
