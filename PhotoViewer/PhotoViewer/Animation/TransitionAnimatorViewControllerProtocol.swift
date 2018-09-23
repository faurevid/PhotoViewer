//
//  TransitionAnimatorViewControllerProtocol.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import UIKit

protocol TransitionAnimatorViewControllerProtocol  {
    
    func willAnimatePresent(withAnimator animator: Any?)
    func animatePresent(withAnimator animator: Any?)
    func willAnimateDismiss(withAnimator animator: Any?)
    func animateDismiss(withAnimator animator: Any?)
}

extension TransitionAnimatorViewControllerProtocol {
    func willAnimatePresent(withAnimator animator: Any?) {
        // Default does nothing
    }
    func animatePresent(withAnimator animator: Any?) {
        // Default does nothing
    }
    func willAnimateDismiss(withAnimator animator: Any?) {
        // Default does nothing
    }
    func animateDismiss(withAnimator animator: Any?) {
        // Default does nothing
    }
}

protocol TransitionAnimatorViewControllerProtocolCaller  {
    func animateDismissIn(fromViewController:UIViewController, toViewController:UIViewController)
    
    func willAnimateDismissIn(fromViewController:UIViewController, toViewController:UIViewController)
    
    func animatePresentIn(fromViewController:UIViewController, toViewController:UIViewController)
    
    func willAnimatePresentIn(fromViewController:UIViewController, toViewController:UIViewController)
}
extension TransitionAnimatorViewControllerProtocolCaller {
    internal func animateDismissIn(fromViewController:UIViewController, toViewController:UIViewController) {
        (fromViewController as? TransitionAnimatorViewControllerProtocol)?.animateDismiss(withAnimator: self)
        (toViewController as? TransitionAnimatorViewControllerProtocol)?.animatePresent(withAnimator: self)
    }
    
    internal func willAnimateDismissIn(fromViewController:UIViewController, toViewController:UIViewController) {
        (fromViewController as? TransitionAnimatorViewControllerProtocol)?.willAnimateDismiss(withAnimator: self)
        (toViewController as? TransitionAnimatorViewControllerProtocol)?.willAnimatePresent(withAnimator: self)
    }
    
    internal func animatePresentIn(fromViewController:UIViewController, toViewController:UIViewController) {
        (fromViewController as? TransitionAnimatorViewControllerProtocol)?.animateDismiss(withAnimator: self)
        (toViewController as? TransitionAnimatorViewControllerProtocol)?.animatePresent(withAnimator: self)
    }
    
    internal func willAnimatePresentIn(fromViewController:UIViewController, toViewController:UIViewController) {
        (fromViewController as? TransitionAnimatorViewControllerProtocol)?.willAnimateDismiss(withAnimator: self)
        (toViewController as? TransitionAnimatorViewControllerProtocol)?.willAnimatePresent(withAnimator: self)
    }
    
}
