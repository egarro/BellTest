//
//  FadePopAnimator.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class FadePopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum TransitionType {
        case navigation
        case modal
    }

    let type: TransitionType
    let duration: TimeInterval

    public init(type: TransitionType, duration: TimeInterval = 0.25) {
        self.type = type
        self.duration = duration

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from)
        else { return }

        if self.type == .navigation, let toViewController = transitionContext.viewController(forKey: .to) {
            transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
