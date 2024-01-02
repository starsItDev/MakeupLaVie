//
//  CollectionViewCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var rsLbl: UILabel!
    @IBOutlet var ratingNo: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favImg: UIImageView!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellView.layer.shadowRadius = 4

    }
    
    
}
