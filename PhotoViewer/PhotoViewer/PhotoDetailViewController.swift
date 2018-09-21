//
//  PhotoDetailViewController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene (Prestataire)  [IT-CE] on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    
    @IBOutlet weak var containerTopLayout: NSLayoutConstraint!
    @IBOutlet weak var containerLeadingLayout: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingLayout: NSLayoutConstraint!
    
    var isExpand = false
    var originalCell: PhotoViewerCell?
    var originalFrame:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoScrollView.contentSize = photoScrollView.frame.size
        photoScrollView.minimumZoomScale = 1.0
        photoScrollView.maximumZoomScale = 5.0
        
    }
    @IBAction func backPressed(_ sender: Any) {
        originalFrame = view.window?.convert(photo.frame, to: view.window)
        self.navigationController?.popViewController(animated: true)
    }
}

extension PhotoDetailViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo
    }
}
