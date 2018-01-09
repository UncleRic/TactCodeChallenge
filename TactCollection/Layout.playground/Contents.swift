

import UIKit

"""
Designing my layout.
Using the variables defined, it's now possible to write a loop that calculates the frame for every cell.
"""

func produceFrames(numberOfItems: Int, numberOfColumns: Int = 5) -> [CGRect] {
    
    let itemHeight = 50
    let itemWidth = 50
    let itemSpacing = 10
    
    let numberOfRows = numberOfColumns / numberOfItems
    let collectionViewHeight = (itemHeight + itemSpacing) * numberOfRows
    
    print("collectionViewHeight = \(collectionViewHeight)")
    var allFrames = [CGRect]()
    
    """
    Computing horizontal positions:
    """
    for itemIndex in 0..<numberOfItems {
        let row = Int(ceil(CGFloat(itemIndex)/CGFloat(numberOfColumns)))
        let column = itemIndex % numberOfColumns
        print("row:\(row) | col:\(column)")
        let xPos = column * (itemWidth + itemSpacing)
        let yPos = row * (itemHeight + itemSpacing)
        
        allFrames.append(CGRect(x: xPos, y: yPos, width: itemWidth, height: itemHeight))
    }
    return allFrames
}
// =============================================================================================

print(produceFrames(numberOfItems:3))

