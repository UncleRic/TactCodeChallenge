//
//  CollectionFlowLayout.swift
//  TactCollection
//
//  Created by Frederick C. Lee on 1/6/18.
//  Copyright © 2018 Amourine Technologies. All rights reserved.
//

import UIKit


// StandardViewLayout: the default View Layout

class StandardViewLayout: UICollectionViewFlowLayout {
    let columns: Int
    override var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else { return super.itemSize }
            let marginsAndInsets = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(columns - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columns)).rounded(.down)
            return CGSize(width: itemWidth, height: itemWidth)
        }
        set {
            super.itemSize = newValue
        }
    }
    
    init(columns: Int,
         minimumInteritemSpacing: CGFloat = 0,
         minimumLineSpacing: CGFloat = 0,
         sectionInset: UIEdgeInsets = .zero) {
        
        self.columns = columns
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds != collectionView?.bounds
        return context
    }
}

// ===================================================================================================

class MorphedViewLayout: UICollectionViewFlowLayout {
    
    // var itemSize = CGSize(width: 50, height: 50)
    var itemSpacing: CGFloat = 10
    
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        let width = CGFloat(numColumns) * itemSize.width + CGFloat(numColumns - 1) * itemSpacing
        let height = CGFloat(numRows) * itemSize.height + CGFloat(numRows - 1) * itemSpacing
        
        return CGSize(width: width, height: height)
    }
    
    private var numberOfItems = 0
    private var numRows = 0
    private var numColumns = 0
    
    override func prepare() {
        guard let collectionView = collectionView
            else { return }
        
        let availableHeight = Int(collectionView.bounds.height + itemSpacing)
        let itemHeightForCalculation = Int(itemSize.height + itemSpacing)
        
        numberOfItems = collectionView.numberOfItems(inSection: 0)
        numRows = availableHeight / itemHeightForCalculation
        numColumns = 5
        layoutAttributes.removeAll()
        
        for itemIndex in 0..<numberOfItems {
            // problem here:
            let row = Int(floor(Float(itemIndex) / Float(numColumns)))
            let column = itemIndex % numColumns
            
            if itemSize.width > 2 {
                itemSize.width -= 2
            }
            
            let xPos = column * Int(itemSize.width + itemSpacing)
            let yPos = row * Int(itemSize.height + itemSpacing)
            
            let index = IndexPath(row: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: index)
            attributes.frame = CGRect(x: CGFloat(xPos), y: CGFloat(yPos), width: itemSize.width, height: itemSize.height)
            layoutAttributes.append(attributes)
            
        }

    }
    
    // -----------------------------------------------------------------------------------------------------
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
     //   guard let collectionView = collectionView else { return true }
//
    //    let availableHeight = newBounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
     //   let possibleRows = Int(availableHeight + itemSpacing) / Int(itemSize.height + itemSpacing)
//
//        return possibleRows != numRows

        return false
    }
    
    // -----------------------------------------------------------------------------------------------------
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//
//        let layoutAttributes = layoutAttributesForElements(in: rect)! as NSArray
//
//        func contains(_ rect2: CGRect) -> Bool {
//            if rect2 == CGRect(x: 0, y: 0, width: 2, height: 50) {
//                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//                layoutAttributes.frame = CGRect(x: 0, y: 0, width: 20, height: 50) // or whatever...
//                return layoutAttributes
//            }
//            else{
//                return layoutAttributes
//            }
//
//        }
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)
        return layoutAttributes.filter { attributes in
            attributes.frame.intersects(rect)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard layoutAttributes.count > 0 else {
            return nil
        }
        return layoutAttributes[indexPath.row]
    }
    
}
