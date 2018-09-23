//
//  PhotoDetailProtocol.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 22/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation

protocol PhotoDetailViewControllerProtocol: class {
    func show(photo: FlickrPhoto)
}

protocol PhotoDetailPresenterProtocol: class {
    func willAppear()
}

