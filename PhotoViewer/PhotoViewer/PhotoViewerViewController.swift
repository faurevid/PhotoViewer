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
    
    //Used for the animation
    var originalFrame:CGRect?
    var originalCell: PhotoViewerCell?
    static let sectionInset: CGFloat = 7.0
    
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
        photoCollectionView.reloadData()
    }
    
    func openDetail() {
        self.performSegue(withIdentifier: "zoomInPhoto", sender: nil)
    }
    
    func startLoader(){
        if let loader = self.loader{
            photoCollectionView.isHidden = true
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
        presenter.willShow(cell: cell, indexPath: indexPath)
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
    
    func getOriginalFrame(fromIndex: IndexPath) -> CGRect {
        //Get cell position for animation
        originalCell = photoCollectionView.cellForItem(at: fromIndex) as? PhotoViewerCell
        originalFrame = calculateFrame(frame: (originalCell?.frame)!)
        return originalFrame!
    }
    
    private func calculateFrame(frame: CGRect) -> CGRect{
        //Calculates the position of the cell in the view
        //Adds collectionView origin to x and y position
        //Substracts collectionView content offset to y position in case collectionView is scrolled down
        return CGRect(x: frame.origin.x + photoCollectionView.frame.origin.x, y: frame.origin.y + photoCollectionView.frame.origin.y - photoCollectionView.contentOffset.y, width: frame.width, height: frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension PhotoViewerViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hides the keyboard and launches the research
        searchBar.resignFirstResponder()
        presenter.fetchPhoto(fromSearch: searchBar.text!)
    }
}
