//
//  CategoriesCollectionViewCell.swift
//  TabBar
//
//  Created by Rao Ahmad on 25/07/2023.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoriesCellLabel: UILabel!
    
    override var isSelected: Bool {
            didSet {
                updateCellSelection()
            }
        }

        override func awakeFromNib() {
            super.awakeFromNib()
            // Additional setup code
            updateCellSelection()
        }

        private func updateCellSelection() {
//            if isSelected {
//                cellView.backgroundColor = UIColor.red
//                categoriesCellLabel.textColor = UIColor.white
//            } else {
//                cellView.backgroundColor = UIColor(named: "white-gray")
//                categoriesCellLabel.textColor = UIColor(named: "black-white")
//            }
        }
}
