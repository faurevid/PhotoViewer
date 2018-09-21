//
//  PhotoViewerProtocol.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene (Prestataire)  [IT-CE] on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation

protocol PhotoViewerViewControllerProtocol: class {
    
}

protocol PhotoViewerPresenterProtocol: class {
    func numberOfPhotos() -> Int
    func willShow(cell: PhotoViewerCell, indexPath: IndexPath)
}
