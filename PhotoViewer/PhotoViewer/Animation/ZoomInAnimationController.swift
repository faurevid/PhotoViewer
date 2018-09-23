//
//  ZoomInAnimationController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import UIKit

class ZoomInAnimationController: NSObject, UIViewControllerAnimatedTransitioning, TransitionAnimatorViewControllerProtocolCaller{
    var duration = 0.5
    var presenting = true
    
    private var interactionController: SlideInteractionController?
    var originalFrame: CGRect?
    var endingFrame: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            animatePresent(transitionContext)
        } else {
            animateDismiss(transitionContext)
        }
    }
    
    var presentingViewSnapshot:UIView?
    
    
    func animatePresent(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from)?.topViewControllerIfNeeded(),
            let toViewController = transitionContext.viewController(forKey: .to)?.topViewControllerIfNeeded(),
            let toView = transitionContext.viewController(forKey: .to)?.view else {
                return
        }
        
        originalFrame = (fromViewController as? PhotoViewerViewController)?.originalFrame
      
        let containerView = transitionContext.containerView
        
        guard let center = originalFrame
             else {
                return
        }
        let iView = UIImageView(image: (fromViewController as! PhotoViewerViewController).originalCell?.photo.image)
        iView.contentMode = .scaleAspectFit
        
        presentingViewSnapshot = iView
        
        containerView.insertSubview(iView, at: 0)
        
        toView.layoutIfNeeded()
        endingFrame = (toViewController as? PhotoDetailViewController)?.photo.frame
        
        iView.frame = center
        iView.backgroundColor = .clear
        iView.clipsToBounds = true
        containerView.addSubview(iView)
        
        guard let fromViewSnapshot = toViewController.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        fromViewSnapshot.alpha = 0
        containerView.addSubview(fromViewSnapshot)
        
        self.willAnimatePresentIn(fromViewController: fromViewController, toViewController: toViewController)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                options:[ .curveEaseOut],
                                animations: {
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 6/8, animations: {
                                        iView.frame = self.endingFrame!
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 6/8, relativeDuration: 1, animations: {
                                        fromViewSnapshot.alpha = 1
                                    })
                                    
                                    self.animatePresentIn(fromViewController: fromViewController, toViewController: toViewController)
                                    
        }, completion: { (finished) in
            iView.removeFromSuperview()
            containerView.addSubview(toView)
            transitionContext.completeTransition(finished)
        })
    }
    
    func animateDismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to)?.topViewControllerIfNeeded(),
            let fromViewController = transitionContext.viewController(forKey: .from) as? PhotoDetailViewController,
            let toView = transitionContext.viewController(forKey: .to)?.view else {
                return
        }
        
        originalFrame = fromViewController.originalFrame
        endingFrame = (toViewController as? PhotoViewerViewController)?.originalFrame
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        
        let iView = UIImageView(image: (fromViewController.photo.image))
        iView.contentMode = .scaleAspectFit
        iView.frame = originalFrame!
        
        containerView.addSubview(iView)
        
        self.willAnimateDismissIn(fromViewController: fromViewController, toViewController: toViewController)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                options:[.curveEaseIn],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 6/8, animations: {
                                        iView.frame = self.endingFrame!
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 6/8, relativeDuration: 1, animations: {
                                        iView.alpha = 0
                                    })
                                    
                                    self.animateDismissIn(fromViewController: fromViewController, toViewController: toViewController)
        }, completion: { (finished) in
            self.presentingViewSnapshot?.removeFromSuperview()
            iView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
    
}
