//
//  PhotoDetailPresenter.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 22/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailPresenter {
    weak var view: PhotoDetailViewControllerProtocol!
    var flickrPhotos = [FlickrPhoto]()
    var currentIndex: Int = 0
    
    init(view: PhotoDetailViewControllerProtocol!, listOfPhotos: [FlickrPhoto], index: Int) {
        self.view = view
        self.flickrPhotos = listOfPhotos
        self.currentIndex = index
    }
}

extension PhotoDetailPresenter: PhotoDetailPresenterProtocol{
    func willAppear() {
        //Shows the photo at selected index
        view.show(photo: flickrPhotos[currentIndex])
    }
}
