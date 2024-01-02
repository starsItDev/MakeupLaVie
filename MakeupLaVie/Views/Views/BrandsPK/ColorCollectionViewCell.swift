//
//  ColorCollectionViewCell.swift
//  TabBar
//
//  Created by Rao Ahmad on 26/07/2023.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colourButton: UIButton!
   
    @IBOutlet weak var colorCellView: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }
        
        private func setupUI() {
            colorCellView.layer.borderWidth = 2.0
            colorCellView.layer.borderColor = UIColor.gray.cgColor
        }
}
