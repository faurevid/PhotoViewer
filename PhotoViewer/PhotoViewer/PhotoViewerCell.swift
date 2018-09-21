//
//  PhotoViewerCell.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene (Prestataire)  [IT-CE] on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoViewerCellProtocol {
    func show(image: UIImage)
}

class PhotoViewerCell: UICollectionViewCell, PhotoViewerCellProtocol{
    
    @IBOutlet weak var photo: UIImageView!
    
    func show(image: UIImage) {
        photo.image = image
    }
    
    
}
