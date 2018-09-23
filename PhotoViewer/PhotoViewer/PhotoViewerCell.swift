//
//  PhotoViewerCell.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoViewerCellProtocol {
    func show(image: NSURL)
}

class PhotoViewerCell: UICollectionViewCell, PhotoViewerCellProtocol{
    
    @IBOutlet weak var photo: UIImageView!
    
    func show(image: NSURL) {
        photo.load(url: image as URL)
    }
    
    
}
