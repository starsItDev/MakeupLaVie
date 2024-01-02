//
//  GridCollectionViewCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 26/05/2023.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet var categoryImg: UIImageView!
    @IBOutlet var categoryLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLbl.layer.shadowColor = UIColor.black.cgColor
        categoryLbl.layer.shadowOpacity = 2
        categoryLbl.layer.shadowOffset = CGSize(width: 2, height: 2)
        categoryLbl.layer.shadowRadius = 4
        
        
    }

}
