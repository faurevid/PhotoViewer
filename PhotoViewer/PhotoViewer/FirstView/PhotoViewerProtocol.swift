//
//  PhotoViewerProtocol.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoViewerViewControllerProtocol: class {
    func reloadData()
    func openDetail()
    func startLoader()
    func stopLoader()
    func displayError(error: String)
}

protocol PhotoViewerPresenterProtocol: class {
    func numberOfPhotos() -> Int
    func willShow(cell: PhotoViewerCell, indexPath: IndexPath)
    func prepare(for segue: UIStoryboardSegue)
    func openDetail(originalCell: PhotoViewerCell, indexPath: IndexPath)
    func fetchPhoto(fromSearch: String, pagination: Int)
}
