//
//  FlickrPhoto.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 22/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit
struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
    var photoImage : UIImage? {
        if let data = try? Data(contentsOf: photoUrl as URL) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
}
