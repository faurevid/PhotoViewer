//
//  SlideInteractionController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import UIKit

class SlideInteractionController: UIPercentDrivenInteractiveTransition {
    
    private(set) var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
    
    
    private func prepareGestureRecognizer(in view: UIView) {
        
        let gesture = UIPanGestureRecognizer(target: self,
                                             action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        guard let gestureSuperView = gestureRecognizer.view?.superview else {
            return
        }
        
        let translation = gestureRecognizer.translation(in: gestureSuperView)
        var progress = (translation.y / gestureSuperView.bounds.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            viewController?.dismiss(animated: true, completion: nil)
            
        case .changed:
            shouldCompleteTransition = progress > 0.3
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}

