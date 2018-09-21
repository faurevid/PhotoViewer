//
//  PhotoViewerViewController.swift
//  PhotoViewer
//
//  Created by FAURE-VIDAL Laurene (Prestataire)  [IT-CE] on 21/09/2018.
//  Copyright © 2018 FAURE-VIDAL Laurene. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewerViewController: UIViewController{
    var presenter : PhotoViewerPresenterProtocol!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //Animation
    var originalFrame:CGRect?
    var originalCell: PhotoViewerCell?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = PhotoViewerPresenter(view: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zoomInPhoto",
            let destination = segue.destination as? PhotoDetailViewController {
            //destination.transaction = selectedTransaction
            destination.originalCell = originalCell
        }
    }
}
//MARK: PhotoViewerViewControllerProtocol
extension PhotoViewerViewController: PhotoViewerViewControllerProtocol{
    
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
    
    func calculateSectionInset() -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset: CGFloat = calculateSectionInset()
        let photoWidth = (photoCollectionView.collectionViewLayout.collectionView!.frame.size.width - inset * 2)/3
        return CGSize(width: photoWidth, height: photoWidth)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        originalCell = collectionView.cellForItem(at: indexPath) as? PhotoViewerCell
        if let cell = originalCell {
            originalFrame = view.window?.convert(cell.frame, to: view.window)
        }
        
        self.performSegue(withIdentifier: "zoomInPhoto", sender: nil)
    }
}
