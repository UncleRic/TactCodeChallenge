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

class TactLayout: UICollectionViewLayout {
    
    override var collectionViewContentSize: CGSize {
             return CGSize.zero
    }
    
    override func prepare() {

    }
    
}

// ===================================================================================================

class MainViewController: UIViewController {
    
    @IBOutlet weak var numberInputField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myLayout: UICollectionViewLayout?
    var tactLayout:TactLayout = TactLayout()
    
    var numberOfMemberCellsOfSection = 0
    
    // MARK: - Initialization:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLayout =  UICollectionViewLayout()
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellQueueID, for: indexPath)
        if let textField = cell.contentView.viewWithTag(1) as? UITextField {
            textField.text = String(indexPath.item)
        }
        return cell
    }
}

// ===================================================================================================

extension UIViewController: UICollectionViewDelegate {
    
}

