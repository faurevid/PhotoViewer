//
//  PhotoDetailViewController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailViewController: UIViewController {
    
    var presenter : PhotoDetailPresenterProtocol!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    
    //MARK: Landscape mode management
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomLandscapeConstraint: NSLayoutConstraint!
    var portraitBottomContraint : NSLayoutConstraint!
    var landscapeBottomContraint : NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewTopLandscapeConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    var portraitTopContraint : NSLayoutConstraint!
    var landscapeTopContraint : NSLayoutConstraint!
    
    //MARK: Used for the animation
    var originalCell: PhotoViewerCell?
    var originalFrame:CGRect?
    var currentIndex: Int = 0
    
    //MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        presenter.willAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = presenter.getCurrentIndex()
        
        //Gives the possibility to zoom on the image
        photoScrollView.contentSize = photoScrollView.frame.size
        photoScrollView.minimumZoomScale = 1.0
        photoScrollView.maximumZoomScale = 5.0
        
        //Adds a long press Gesture recognizer to the UIImageView
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PhotoDetailViewController.longPressed(sender:)))
        self.photo.addGestureRecognizer(longPressRecognizer)
        
        //Keeps a reference of the constraints for portrait/landscape mode management
        portraitBottomContraint = scrollViewBottomConstraint
        landscapeBottomContraint = scrollViewBottomLandscapeConstraint
        
        portraitTopContraint = scrollViewTopConstraint
        landscapeTopContraint = scrollViewTopLandscapeConstraint
        
        //Handles the constraint when view is load
        handleOrientation()
        
        //Defining the Various Swipe directions (left, right, up, down)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        originalFrame = calculateFrame(frame: photo.frame)
    }
    
    /**
     Calculates the position of the cell in the view
     
     This method accepts a frame representing the original view and calculates its frame in the window.
     Adds scrollView origin to x and y position
     Adds containerView origin to x and y position
   
     - Parameters:
        - frame: The frame representing the original view
     
     - returns: The frame of the view in the window
     */
    private func calculateFrame(frame: CGRect) -> CGRect{
        return CGRect(x: frame.origin.x + photoScrollView.frame.origin.x + containerView.frame.origin.x, y: frame.origin.y + photoScrollView.frame.origin.y + containerView.frame.origin.y, width: frame.width, height: frame.height)
    }
    
    //MARK: Longpress management
    /**
     Gives the possibility to share the photo.
     Set up activity view controller with image to share
     */
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        let imageToShare = [ photo.image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
       
        //Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    //MARK: Orientation management
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        handleOrientation()
    }
    
    /**
        Handles the device orientation. On landscape mode, image is fullScreen
     */
    private func handleOrientation(){
        if UIDevice.current.orientation.isLandscape {
            portraitBottomContraint.isActive = false
            landscapeBottomContraint.isActive = true
            
            portraitTopContraint.isActive = false
            landscapeTopContraint.isActive = true
            
            photoTitle.isHidden = true
        } else {
            landscapeBottomContraint.isActive = false
            portraitBottomContraint.isActive = true
            
            landscapeTopContraint.isActive = false
            portraitTopContraint.isActive = true
            
            photoTitle.isHidden = false
        }
        containerView.layoutIfNeeded()
    }
    
    //MARK: Gesture management
    /**
        Handles swipe right, left and down to switch to the next or previous image, or to close the detail view and go back to the collection
    */
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            presenter.openPreviousPhoto()
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            presenter.openNextPhoto()
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            closeDetail()
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        closeDetail()
    }
    
    /** Prepares the animation before closing */
    private func closeDetail(){
        originalFrame = calculateFrame(frame: photo.frame)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
//MARK: ScrollView delegate
extension PhotoDetailViewController: UIScrollViewDelegate{
    //MARK: Zoom management
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo
    }
    
    /** Closes view on drag down */
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(scrollView.zoomScale == 1.0){ // Only closes view on scroll down if image is not zoomed in
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if translation.y >= 0 {
                //Scroll down
                closeDetail()
            }
        }
    }
}
//MARK: PhotoDetailViewControllerProtocol
extension PhotoDetailViewController: PhotoDetailViewControllerProtocol, CAAnimationDelegate{
    func show(photo: FlickrPhoto) {
        self.photo.image = photo.photoImage
        self.photoTitle.text = photo.title
    }
    
    /**
     Animates the push transition from left to right if user opens previous photo
     - Parameters:
        - viewController: the next viewController
        - fromLeft: must the viewController be opened from left
     */
    func openPhoto(viewController: PhotoDetailViewController, fromLeft: Bool) {
        if(fromLeft){
            let transition = CATransition.init()
            transition.duration = 0.35
            transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.delegate = self
            view.window!.layer.add(transition, forKey: kCATransition)
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
