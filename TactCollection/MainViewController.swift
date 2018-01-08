//
//  MainViewController.swift
//  tactCode
//
//  Created by Frederick C. Lee on 1/3/18.
//  Copyright © 2018 Amourine Technologies. All rights reserved.
//

import UIKit

let cellQueueID = "cell"

class TactCell: UICollectionViewCell {
    var textVield:UITextField?
}


// ===================================================================================================

class MainViewController: UIViewController {
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var numberInputField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var numberOfMemberCellsOfSection = 0
    var maxNumberOfCells:Int?
    var alternatingRowDataSourceArray:[Int]?
    let standardViewLayout:StandardViewLayout!
    static let cellsPerRow = 5
    
    var rows:Int {
        return Int(ceil(CGFloat(numberOfMemberCellsOfSection)/CGFloat(MainViewController.cellsPerRow)))
    }
    
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
        
        maxNumberOfCells = rows * MainViewController.cellsPerRow
        var origArray = Array(repeating: 0, count: maxNumberOfCells!)
        
        for cellID in 0..<numberOfMemberCellsOfSection {
            origArray[cellID] = cellID
        }
        
        // 2) Break the array in slices per computed row:
        
        var newArray = [Int]()
        var k = 0
        var col = columns - 1
        var reverse = false
        
        for _ in 0..<rows {
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
    
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        numberOfMemberCellsOfSection = 0
        maxNumberOfCells = nil
        numberInputField.text = ""
        alternatingRowDataSourceArray = nil
        titleLabel.text = title.standard.rawValue
        titleLabel.isHidden = true
        toolBar.items![toolbarItem.standard.rawValue].isEnabled = false
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = false
        toolBar.items![toolbarItem.morphed.rawValue].isEnabled = false
        collectionView.collectionViewLayout = standardViewLayout
        collectionView.reloadData()
    }
    
    @IBAction func standardAction(_ sender: Any) {
        collectionView.collectionViewLayout = standardViewLayout
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = true
        toolBar.items![toolbarItem.standard.rawValue].isEnabled = false
        alternatingRowDataSourceArray = nil
        collectionView.reloadData()
    }
    
    @IBAction func altRowsAction(_ sender: UIBarButtonItem) {
        guard nil == alternatingRowDataSourceArray else {return}
        collectionView.collectionViewLayout = standardViewLayout
        toolBar.items![toolbarItem.altRows.rawValue].isEnabled = false
        toolBar.items![toolbarItem.standard.rawValue].isEnabled = true
        AlternatingRowsArray()
        titleLabel.text = title.altered.rawValue
        collectionView.reloadData()
    }
    
    
    @IBAction func morphedAction(_ sender: UIBarButtonItem) {
        collectionView.collectionViewLayout = MorphedViewLayout()
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
        return true
    }
}

// ===================================================================================================
// UICollectionViewDataSource:

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfSections: Int) -> Int {
        return  maxNumberOfCells ?? numberOfMemberCellsOfSection
    }
    
    // **** Populating the cell ****:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dataInt = 0
        if let alternatingRowDataSourceArray = alternatingRowDataSourceArray {
            dataInt = alternatingRowDataSourceArray[indexPath.item]
        } else {
            dataInt = indexPath.item
        }
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellQueueID, for: indexPath)
        if let textField = cell.contentView.viewWithTag(1) as? UITextField {
            textField.isHidden = (dataInt == 0 && indexPath.row > 0)
            textField.text = String(dataInt)
        }
        
        return cell
    }
}

