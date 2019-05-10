//
//  UIViewController.swift
//  SMFInventory
//
//  Created by Emerio-Mac2 on 18/09/18.
//  Copyright © 2018 Emerio-Mac2. All rights reserved.
//

import UIKit

extension UIViewController : UICollectionViewDelegateFlowLayout {
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
//    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let bounds = collectionView.bounds
//        let heightVal = self.view.frame.height
//        let widthVal = self.view.frame.width
//        let cellSize = (heightVal < widthVal) ? bounds.height/2 : bounds.width/2
//        
//        return CGSize(width:cellSize-10, height:cellSize-10)
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }
//    
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
}

