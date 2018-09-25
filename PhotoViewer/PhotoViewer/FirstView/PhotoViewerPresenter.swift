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
        self.fetchPhoto(fromSearch: "Cookies", pagination: 1)
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
    
    /**
     Fetches photos from Flickr
     - Parameters:
        - fromSearch: the string to search from
        - pagination: which page of search
 */
    func fetchPhoto(fromSearch: String, pagination: Int){
        //Gets the images from Flickr
        view.startLoader()
        if(pagination == 1){
            //Only empty array if it's a new search
            self.flickrPhotos.removeAll()
        }
        //String encoding to pass in the url
        let encoded = fromSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(PhotoViewerPresenter.apiKey)&tags=\(encoded)&per_page=25&format=json&nojsoncallback=1&page=\(pagination)"
        let url: NSURL = NSURL(string: urlString)!
        let searchTask = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error.debugDescription)")
                DispatchQueue.main.async {self.view.displayError(error: error.debugDescription)}
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
                        DispatchQueue.main.async {self.view.displayError(error: error.debugDescription)}
                        return
                    }
                }
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                guard let photosArray = photosContainer["photo"] as? [NSDictionary], photosArray.count > 0 else {
                    DispatchQueue.main.async {self.view.stopLoader()}
                    return
                }
                
                //Creates the array of photos
                self.flickrPhotos += photosArray.map { photoDictionary in
                    
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
    /** Opens the details of the selected photo */
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


