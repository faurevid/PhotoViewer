//
//  ZoomInAnimationController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import UIKit

/** The class that handles the transitions between views */
class ZoomInAnimationController: NSObject, UIViewControllerAnimatedTransitioning, TransitionAnimatorViewControllerProtocolCaller{
    var duration = 0.5
    var presenting = true
    
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
    
    /** Sets the animation displayed when second view is presented */
    func animatePresent(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from)?.topViewControllerIfNeeded(),
            let toViewController = transitionContext.viewController(forKey: .to)?.topViewControllerIfNeeded(),
            let toView = transitionContext.viewController(forKey: .to)?.view else {
                return
        }
        
        let containerView = transitionContext.containerView

        //Creates a UIImageView that will animate from the cell position on the first view to the photo position on the second view
        let iView = UIImageView(image: (fromViewController as! PhotoViewerViewController).originalCell?.photo.image)
        iView.contentMode = .scaleAspectFit
        
        //The cell position in the first view
        originalFrame = (fromViewController as? PhotoViewerViewController)?.originalFrame
        iView.frame = originalFrame!
    
        //Hides the second view for the beginning of the animation
        toView.alpha = 0
        toView.layoutIfNeeded()
        
        //The photo position in the second view
        endingFrame = (toViewController as? PhotoDetailViewController)?.originalFrame
        
        containerView.addSubview(toView)
        containerView.addSubview(iView)
        
        self.willAnimatePresentIn(fromViewController: fromViewController, toViewController: toViewController)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                options:[ .curveEaseOut],
                                animations: {
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                                        iView.frame = self.endingFrame!
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 6/8, relativeDuration: 1, animations: {
                                        toView.alpha = 1
                                    })
                                    
                                    self.animatePresentIn(fromViewController: fromViewController, toViewController: toViewController)
                                    
        }, completion: { (finished) in
            iView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
    
    
    /** Sets the animation displayed when second view is dismissed */
    func animateDismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to)?.topViewControllerIfNeeded(),
            let fromViewController = transitionContext.viewController(forKey: .from) as? PhotoDetailViewController,
            let toView = transitionContext.viewController(forKey: .to)?.view else {
                return
        }
        
        //The photo position in the second view
        originalFrame = fromViewController.originalFrame
        
        //The cell position in the first view
        endingFrame = (toViewController as? PhotoViewerViewController)?.getOriginalFrame(fromIndex: IndexPath(row: fromViewController.currentIndex, section: 0))
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        
        //Creates a UIImageView that will animate from the photo position on the second view to the cell position on the first view
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
            iView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
    
}
