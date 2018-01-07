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
    
    @IBOutlet weak var numberInputField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var numberOfMemberCellsOfSection = 0
    var dataSourceArray:[Int]?
    
    static let cellsPerRow = 5
    static let rows = 4
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: cellsPerRow,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    // MARK: - Initialization:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberInputField.delegate = self
        collectionView?.collectionViewLayout = columnLayout
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Local
    // Prepping Data from user input integer: Alternating rows of L->R & R->L integers.
    //
    func AlternatingRowsArray() {
        let columns = MainViewController.cellsPerRow
        let rows = MainViewController.rows
       
        // 1) Create an integer array of items per user entry:
        var origArray = [Int]()
        for cellID in 0..<numberOfMemberCellsOfSection {
            origArray.append(cellID)
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
            print(myArray)
            k += columns
            col += columns
            reverse = !reverse
        }
        
        dataSourceArray = newArray
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func morphedLayout() {
        print("-- Morphed Layout() ---")
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Action:
    
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        numberOfMemberCellsOfSection = 0
        numberInputField.text = ""
        dataSourceArray = nil
        collectionView.reloadData()
    }
    
    @IBAction func altRowsAction(_ sender: UIBarButtonItem) {
        guard let _ = dataSourceArray else {return}
        AlternatingRowsArray()
        collectionView.reloadData()
    }
    
    
    @IBAction func morphedAction(_ sender: UIBarButtonItem) {
        morphedLayout()
    }
    
    
    @IBAction func exitAction(_ sender: UIBarButtonItem) {
        exit(0)
    }
}

// ===================================================================================================

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let numberOfCells = Int(numberInputField.text!) else {
            return false
        }
        numberOfMemberCellsOfSection = numberOfCells
        textField.resignFirstResponder()
        collectionView.reloadData()
        return true
    }
}

// ===================================================================================================

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfSections: Int) -> Int {
        return  numberOfMemberCellsOfSection
    }
    
    // **** Populating the cell ****:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dataInt = 0
        if let dataSourceArray = dataSourceArray {
            dataInt = dataSourceArray[indexPath.item]
        } else {
            dataInt = indexPath.item
        }
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellQueueID, for: indexPath)
        if let textField = cell.contentView.viewWithTag(1) as? UITextField {
            textField.text = String(dataInt)
        }
    
        return cell
    }
}

