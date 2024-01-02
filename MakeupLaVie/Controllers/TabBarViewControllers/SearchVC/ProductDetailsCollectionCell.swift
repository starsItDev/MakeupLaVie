//
//  ProductDetailsCollectionCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 31/05/2023.
//

import UIKit

class ProductDetailsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        imgView.layer.shadowColor = UIColor.black.cgColor
//        imgView.layer.shadowOpacity = 0.5
//        imgView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        imgView.layer.shadowRadius = 4
    }
}
