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
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //Used for the animation
    var originalFrame:CGRect?
    var originalCell: PhotoViewerCell?
    static let sectionInset: CGFloat = 7.0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = PhotoViewerPresenter(view: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue)
    }
}
//MARK: PhotoViewerViewControllerProtocol
extension PhotoViewerViewController: PhotoViewerViewControllerProtocol{
    func reloadData() {
        photoCollectionView.reloadData()
    }
    
    func openDetail() {
        self.performSegue(withIdentifier: "zoomInPhoto", sender: nil)
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
        //Saves position for animation
        originalCell = collectionView.cellForItem(at: indexPath) as? PhotoViewerCell
        if let cell = originalCell {
            originalFrame = view.window?.convert(cell.frame, to: view.window)
        }
        presenter.openDetail(originalCell: originalCell!, indexPath: indexPath)
    }
}
