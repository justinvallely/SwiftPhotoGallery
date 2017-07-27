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

    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if let fromVC = transitionContext.viewController(forKey: .from),
            let toView = transitionContext.view(forKey: .to) {

            let containerView = transitionContext.containerView

//            toView.frame = transitionContext.finalFrame(for: toVC)

            containerView.addSubview(toView)
            containerView.bringSubview(toFront: toView)


            let duration = transitionDuration(using: transitionContext)

            let finalFrame = toView.frame

            let xScaleFactor = originFrame.width / finalFrame.width
            let yScaleFactor = originFrame.height / finalFrame.height

            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

            toView.transform = scaleTransform
            toView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
            toView.clipsToBounds = true

            UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, animations: {
                toView.transform = CGAffineTransform.identity
                toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }, completion:{ _ in
                transitionContext.completeTransition(true)
            })

        }

    }

}
