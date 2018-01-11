//
//  MainViewController.swift
//  tactCode
//
//  Created by Frederick C. Lee on 1/3/18.
//  Copyright © 2018 Amourine Technologies. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}


// ===================================================================================================

class MainViewController: UIViewController {
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var numberInputField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let cellID = "MainCell"
    
    var numberOfMemberCellsOfSection = 0
    var maxNumberOfCells:Int?
    var alternatingRowDataSourceArray:[Int]?
    let standardViewLayout:StandardViewLayout!
    
    var selectionMode = false {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
        }
    }
    
    var isStandard = true
    
    static var cellsPerRow = 0
    static var rows = 0
    
    enum toolbarItem:Int {
        case exit = 0
        case reset
        case standard
        case altRows
        case morphed
    }
    
    enum title:String {
        case standard = "Standard"
        case altered = "Alternating Rows"
        case morphed = "Morphed Cells"
    }
    
    // MARK: - Initialization:
    required init?(coder aDecoder: NSCoder) {
        standardViewLayout = StandardViewLayout(
            cellsPerRow: MainViewController.cellsPerRow,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
        super.init(coder: aDecoder)
    }
    
    
    // ===================================================================================================
    
    func countRowsAndColumns() {
        let layouts = standardViewLayout.layoutAttributesForElements(in: collectionView.bounds)!
        var columns = Set<CGFloat>()
        var rows = Set<CGFloat>()
        
        for layout in layouts {
            if layout.representedElementCategory != .cell {continue}
            let x:CGFloat = layout.frame.origin.x
            columns.insert(x)
            let y:CGFloat = layout.frame.origin.y
            rows.insert(y)
        }
        
        MainViewController.cellsPerRow = columns.count
        MainViewController.rows = rows.count
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Private functions
    // 1) Minimum Inter-item Spacing:
    
    private func separatorSize(isInSelectionMode: Bool) -> CGSize {
        // Select Mode: shrink item: make gap wider:
        return selectionMode ? CGSize(width: 24, height: 24) : CGSize(width: 3, height: 3)
    }
    
    // *** VIEW DID LOAD ***
    override func viewDidLoad() {
        super.viewDidLoad()
        numberInputField.delegate = self
        collectionView.collectionViewLayout = standardViewLayout
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Local
    // Prepping Data from user input integer: Alternating rows of L->R & R->L integers.
    //
    func AlternatingRowsArray() {
        let columns = MainViewController.cellsPerRow
        
        // 1) Create an integer array of items per user entry:
        
        maxNumberOfCells = MainViewController.rows * MainViewController.cellsPerRow
        var origArray = Array(repeating: 0, count: maxNumberOfCells!)
        
        for cellID in 0..<numberOfMemberCellsOfSection {
            origArray[cellID] = cellID
        }
        
        // 2) Break the array in slices per computed row:
        
        var newArray = [Int]()
        var k = 0
        var col = columns - 1
        var reverse = false
        
        for _ in 0..<MainViewController.rows {
            var myArray = Array(origArray[k...col])
            if reverse {
                myArray = myArray.reversed()
            }
            newArray = newArray + myArray
            k += columns
            col += columns
            reverse = !reverse
        }
        
        alternatingRowDataSourceArray = newArray
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Action:
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        numberInputField.resignFirstResponder()
    }
    
    @IBAction func resetAction() {
        collectionView.collectionViewLayout = standardViewLayout
        numberOfMemberCellsOfSection = 0
        maxNumberOfCells = nil
        numberInputField.text = ""
        alternatingRowDataSourceArray = nil
        titleLabel.text = title.standard.rawValue
        titleLabel.isHidden = true
        toolBar.items![toolbarItem.standard.rawValue].isEnabled = false
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = false
        toolBar.items![toolbarItem.morphed.rawValue].isEnabled = false
        collectionView.reloadData()
    }
    
    @IBAction func standardAction(_ sender: Any) {
        collectionView.collectionViewLayout = standardViewLayout
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = true
        toolBar.items![toolbarItem.standard.rawValue].isEnabled = false
        toolBar.items![toolbarItem.morphed.rawValue].isEnabled = true
        alternatingRowDataSourceArray = nil
        isStandard = true
        collectionView.reloadData()
    }
    
    @IBAction func altRowsAction(_ sender: UIBarButtonItem) {
        guard nil == alternatingRowDataSourceArray else {return}
        collectionView.collectionViewLayout = standardViewLayout
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = false
        toolBar.items![toolbarItem.standard.rawValue].isEnabled = true
        toolBar.items![toolbarItem.morphed.rawValue].isEnabled = true
        AlternatingRowsArray()
        titleLabel.text = title.altered.rawValue
        collectionView.reloadData()
    }
    
    
    @IBAction func morphedAction(_ sender: UIBarButtonItem) {
        collectionView.collectionViewLayout = MorphedViewLayout()
        toolBar.items![toolbarItem.standard.rawValue].isEnabled = true
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = true
        toolBar.items![toolbarItem.morphed.rawValue].isEnabled = false
        titleLabel.text = title.morphed.rawValue
    }
    
    
    @IBAction func exitAction(_ sender: UIBarButtonItem) {
        exit(0)
    }
    
    
    
}

// ===================================================================================================
// UITextField Delegate:

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let numberOfCells = Int(numberInputField.text!) else {
            textField.text = ""
            return false
        }
        
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = true
        toolBar.items![toolbarItem.morphed.rawValue].isEnabled = true
        titleLabel.isHidden = false
        titleLabel.text = title.standard.rawValue
        
        numberOfMemberCellsOfSection = numberOfCells
        
        textField.resignFirstResponder()
        collectionView.reloadData()
        countRowsAndColumns()
        return true
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        resetAction()
        return true
    }
}

// ===================================================================================================
// UICollectionViewDataSource:

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfSections: Int) -> Int {
        return  maxNumberOfCells ?? numberOfMemberCellsOfSection
    }
    
    // -----------------------------------------------------------------------------------------------------
    // Populating the cell:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dataInt = 0
        if let alternatingRowDataSourceArray = alternatingRowDataSourceArray {
            dataInt = alternatingRowDataSourceArray[indexPath.item]
        } else {
            dataInt = indexPath.item
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MainCollectionViewCell
        
        cell.backgroundColor = UIColor(hue: CGFloat(indexPath.item % 6) * CGFloat(1.0 / 6.0),
                                       saturation: 0.80, brightness: 0.75, alpha: 1.0)
        
        cell.label.isHidden = (dataInt == 0 && indexPath.row > 0)
        cell.label.text = String(dataInt)
        
        return cell
    }
}

// ===================================================================================================
// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    // Animate Touch: Adjust borders about all cells:
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.25) { self.selectionMode = !self.selectionMode }
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return separatorSize(isInSelectionMode: selectionMode).width
        
    }
    
    // -----------------------------------------------------------------------------------------------------
    
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





