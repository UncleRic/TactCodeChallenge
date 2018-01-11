//
//  CustomCollectionFlowLayout.swift
//  TactCollection
//
//  Created by Frederick C. Lee on 1/10/18.
//  Copyright © 2018 Amourine Technologies. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - UICollectionViewFlowLayout  (SDK)
    // 2) Minimum Line
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return separatorSize(isInSelectionMode: selectionMode).height
    }
    
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Private functions
    // 1) Minimum Inter-item Spacing:
    
    private func separatorSize(isInSelectionMode: Bool) -> CGSize {
        // Select Mode: shrink item: make gap wider:
        return selectionMode ? CGSize(width: 24, height: 24) : CGSize(width: 3, height: 3)
    }
    
    // -----------------------------------------------------------------------------------------------------
    // Optional Layout Adjustment
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalRowHeight: CGFloat = 100
        let widthRatio: CGFloat
        
        switch indexPath.item % 4 {
        case 0, 3: widthRatio = (2.0 / 3.0)
        case 1, 2: widthRatio = (1.0 / 3.0)
        default: widthRatio = 1.0
        }
        
        var width:CGFloat = 0.0; var height:CGFloat = 0.0
        
        if isStandard {
            width = 50.0; height = 50.0
        } else {
            width = (collectionView.bounds.width - separatorSize(isInSelectionMode: selectionMode).width) * widthRatio
            height = totalRowHeight - separatorSize(isInSelectionMode: selectionMode).height
        }
        
        return CGSize(width: width, height: height)
    }
}
