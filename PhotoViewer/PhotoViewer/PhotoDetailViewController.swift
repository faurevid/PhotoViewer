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
    
    //Used for the animation
    var originalCell: PhotoViewerCell?
    var originalFrame:CGRect?
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.willAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gives the possibility to zoom on the image
        photoScrollView.contentSize = photoScrollView.frame.size
        photoScrollView.minimumZoomScale = 1.0
        photoScrollView.maximumZoomScale = 5.0
        
        //Adds a long press Gesture recognizer to the UIImageView
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PhotoDetailViewController.longPressed(sender:)))
        self.photo.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        //Gives the possibility to share the photo
        //Set up activity view controller with image to share
        let imageToShare = [ photo.image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
       
        //Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        //Prepares the animation
        originalFrame = view.window?.convert(photo.frame, to: view.window)
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: ScrollView delegate
extension PhotoDetailViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //Scales the photo when zooming
        return photo
    }
}
//MARK: PhotoDetailViewControllerProtocol
extension PhotoDetailViewController: PhotoDetailViewControllerProtocol{
    func show(photo: FlickrPhoto) {
        self.photo.image = photo.photoImage
        self.photoTitle.text = photo.title
    }
    
    
}
