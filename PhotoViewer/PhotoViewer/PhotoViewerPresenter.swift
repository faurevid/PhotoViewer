//
//  PhotoViewerPresenter.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene (Prestataire)  [IT-CE] on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewerPresenter {
    weak var view: PhotoViewerViewControllerProtocol!
    
    init(view: PhotoViewerViewControllerProtocol!){
        self.view = view
    }
}

//MARK: PhotoViewerPresenterProtocol
extension PhotoViewerPresenter: PhotoViewerPresenterProtocol{
    func numberOfPhotos() -> Int {
        return 100
    }
    func willShow(cell: PhotoViewerCell, indexPath: IndexPath) {
      /*  guard !credits.isEmpty else{
            return
        }
        let data = credits[indexPath.row]*/
        
        cell.show(image: UIImage(named: "test")!)
    }
}
