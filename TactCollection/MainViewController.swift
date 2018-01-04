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

class TactLayout: UICollectionViewLayout {
    
    override var collectionViewContentSize: CGSize {
             return CGSize.zero
    }
    
    override func prepare() {

    }
    
}

class MainViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    var myLayout: UICollectionViewLayout?
    var tactLayout:TactLayout = TactLayout()
    
    var numberOfMemberCellsOfSection = 20
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLayout =  UICollectionViewLayout()
    }

    // -----------------------------------------------------------------------------------------------------
    
    
    @IBAction func exitAction(_ sender: UIBarButtonItem) {
        exit(0)
    }
}

// ===================================================================================================

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfSections: Int) -> Int {
        return numberOfMemberCellsOfSection
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

