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
//MARK: PhotoDetailPresenterProtocol
extension PhotoDetailPresenter: PhotoDetailPresenterProtocol{
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func willAppear() {
        //Shows the photo at selected index
        view.show(photo: flickrPhotos[currentIndex])
    }
    
    //MARK: Navigation
    func openNextPhoto(){
        openPhotoAt(index: currentIndex + 1)
    }
    func openPreviousPhoto(){
        openPhotoAt(index: currentIndex - 1)
    }
    
    private func openPhotoAt(index: Int){
        if(index >= 0 && index < flickrPhotos.count){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextPhoto = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
            let nextPresenter = PhotoDetailPresenter(view: nextPhoto, listOfPhotos: flickrPhotos, index: index)
            nextPhoto.presenter = nextPresenter
            view.openPhoto(viewController: nextPhoto, fromLeft: index < currentIndex)
        }
    }
}

