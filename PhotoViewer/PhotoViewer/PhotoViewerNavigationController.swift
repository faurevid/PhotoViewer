//
//  PhotoViewerNavigationController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import UIKit

class PhotoViewerNavigationController : UINavigationController, UINavigationControllerDelegate{
    lazy var zoomInTransitionAnimator = ZoomInAnimationController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Handles the "Zoom in" animations between the two views
        // Push
        if fromVC is PhotoViewerViewController, toVC is PhotoDetailViewController {
            zoomInTransitionAnimator.presenting = true
            return zoomInTransitionAnimator
        }
        
        // Pop
        if toVC is PhotoViewerViewController, fromVC is PhotoDetailViewController {
            zoomInTransitionAnimator.presenting = false
            return zoomInTransitionAnimator
        }
        
        return nil
    }

}
