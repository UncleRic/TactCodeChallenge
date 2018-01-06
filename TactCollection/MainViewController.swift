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
    static let cellsPerRow = 5
    static var cellCount = 0
    static var cellFlag = false
    
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
    
    func standardLayout() {
        print("Standard Layout: \(numberOfMemberCellsOfSection)")
        collectionView.reloadData()
    }
    
    func morphedLayout() {
        
    }
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Action:
    
    
    @IBAction func resetAction(_ sender: UIBarButtonItem) {
        numberOfMemberCellsOfSection = 0
        numberInputField.text = ""
        standardLayout()
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
        standardLayout()
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
        if MainViewController.cellCount > (MainViewController.cellsPerRow - 1) {
            MainViewController.cellCount = 0
            MainViewController.cellFlag = !MainViewController.cellFlag
        }
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellQueueID, for: indexPath)
        if let textField = cell.contentView.viewWithTag(1) as? UITextField {
            // textField.text = String(indexPath.item)
            textField.text = String(MainViewController.cellFlag)
        }
        MainViewController.cellCount += 1
        return cell
    }
}

