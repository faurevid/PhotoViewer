//
//  PhotoViewerPresenter.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewerPresenter {
    weak var view: PhotoViewerViewControllerProtocol!
    static let apiKey = "c7a39c9fbc06d748ac12086832ecfbac"
    var flickrPhotos = [FlickrPhoto]()
    var originalCell: PhotoViewerCell?
    var selectedIndex: Int = 0
    
    init(view: PhotoViewerViewControllerProtocol!){
        self.view = view
        self.fetchPhoto(fromSearch: "Cuisine")
    }
}

//MARK: PhotoViewerPresenterProtocol
extension PhotoViewerPresenter: PhotoViewerPresenterProtocol{
    func numberOfPhotos() -> Int {
        return flickrPhotos.count
    }
    func willShow(cell: PhotoViewerCell, indexPath: IndexPath) {
        guard !flickrPhotos.isEmpty else{
            return
        }
        let data = flickrPhotos[indexPath.row]
        
        cell.show(image: data.photoUrl)
    }
    
    
    func fetchPhoto(fromSearch: String){
        //Gets the images from Flickr
        let encoded = fromSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(PhotoViewerPresenter.apiKey)&tags=\(encoded)&per_page=25&format=json&nojsoncallback=1"
        let url: NSURL = NSURL(string: urlString)!
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error)")
                return
            }
            
            do {
                //Serialization of JSON result
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                guard let results = resultsDictionary else { return }
                
                if let statusCode = results["code"] as? Int {
                    if statusCode == 100 { //invalidAccessErrorCode
                        let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                        print("Error with access: \(invalidAccessError)")
                        return
                    }
                }
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                
                //Creates the array of photos
                self.flickrPhotos = photosArray.map { photoDictionary in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                }
                //Displays the photos in the collectionView
                DispatchQueue.main.async {self.view.reloadData()}
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                return
            }
            
        })
        searchTask.resume()
    }
    
    func openDetail(originalCell: PhotoViewerCell, indexPath: IndexPath) {
        self.originalCell = originalCell
        self.selectedIndex = indexPath.row
        view.openDetail()
    }
    
    func prepare(for segue: UIStoryboardSegue) {
        if segue.identifier == "zoomInPhoto",
            let destination = segue.destination as? PhotoDetailViewController {
            //Gives the datas to the presenters and sets it to the ViewController
            let detailPresenter = PhotoDetailPresenter(view: destination, listOfPhotos: flickrPhotos, index: selectedIndex)
            destination.presenter = detailPresenter
            destination.originalCell = originalCell
        }
    }
    
}


