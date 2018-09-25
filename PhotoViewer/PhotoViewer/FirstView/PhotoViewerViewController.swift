//
//  PhotoViewerViewController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewerViewController: UIViewController{
    var presenter : PhotoViewerPresenterProtocol!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var noResultLbl: UILabel!
    
    //MARK: Pagination
    var currentPagination: Int = 1
    var isNewDataLoading:Bool = false
    
    //MARK: Used for the animation
    var originalFrame:CGRect?
    var originalCell: PhotoViewerCell?
    static let sectionInset: CGFloat = 7.0
    
    //MARK: LifeCycle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = PhotoViewerPresenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue)
    }
}
//MARK: PhotoViewerViewControllerProtocol
extension PhotoViewerViewController: PhotoViewerViewControllerProtocol{
    func reloadData() {
        stopLoader()
        isNewDataLoading = false
        photoCollectionView.reloadData()
    }
    
    func openDetail() {
        self.performSegue(withIdentifier: "zoomInPhoto", sender: nil)
    }
    
    //MARK: Loader Management
    func startLoader(){
        if let loader = self.loader{
            photoCollectionView.isHidden = currentPagination == 1
            noResultLbl.isHidden = true
            loader.startAnimating()
        }
    }
    func stopLoader(){
        if let loader = self.loader{
            if(presenter.numberOfPhotos() > 0){
                noResultLbl.isHidden = true
                photoCollectionView.isHidden = false
            }
            else{
                noResultLbl.text = String(format: "Oops! There are no matches for “%@”.\r\nPlease try broadening your search.", searchBar.text!)
                photoCollectionView.isHidden = true
                noResultLbl.isHidden = false
            }
            loader.stopAnimating()
        }
    }
    
    //MARK: Error display
    func displayError(error: String) {
        stopLoader()
        noResultLbl.text = "An error occured, please try again"
    }
}

//MARK: CollectionView Manager
extension PhotoViewerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionCell", for: indexPath) as? PhotoViewerCell else{
            return UICollectionViewCell()
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.presenter.willShow(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Sets the cell size so that they expand according to the size of the device
        let inset: CGFloat = PhotoViewerViewController.sectionInset
        let photoWidth = (photoCollectionView.collectionViewLayout.collectionView!.frame.size.width - inset * 2)/3 //3 cells per line
        return CGSize(width: photoWidth, height: photoWidth)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoViewerViewController.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoViewerViewController.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        originalFrame = getOriginalFrame(fromIndex: indexPath)
        presenter.openDetail(originalCell: originalCell!, indexPath: indexPath)
    }
    
    /** Get cell position for animation */
    func getOriginalFrame(fromIndex: IndexPath) -> CGRect {
        originalCell = photoCollectionView.cellForItem(at: fromIndex) as? PhotoViewerCell
        originalFrame = calculateFrame(frame: (originalCell?.frame)!)
        return originalFrame!
    }
    

    /**
      Calculates the position of the cell in the view
     
      This method accepts a frame representing the original view and calculates its frame in the window.
     Adds collectionView origin to x and y position
     Substracts collectionView content offset to y position in case collectionView is scrolled down
     - Parameters:
        - frame: The frame representing the original view
     
     - returns: The frame of the view in the window
     */
    private func calculateFrame(frame: CGRect) -> CGRect{
        return CGRect(x: frame.origin.x + photoCollectionView.frame.origin.x, y: frame.origin.y + photoCollectionView.frame.origin.y - photoCollectionView.contentOffset.y, width: frame.width, height: frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Hides the keyboard
        searchBar.resignFirstResponder()
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //Detects scroll to bottom to launch pagination
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if !isNewDataLoading{
                isNewDataLoading = true
                currentPagination += 1
                presenter.fetchPhoto(fromSearch: searchBar.text!, pagination: currentPagination)
            }
        }
    }
}

extension PhotoViewerViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hides the keyboard and launches the research
        searchBar.resignFirstResponder()
        //With a new search, pagination is set back to 1
        currentPagination = 1
        presenter.fetchPhoto(fromSearch: searchBar.text!, pagination: currentPagination)
    }
}
