//
//  SpecialCollectionCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 26/05/2023.
//

import UIKit

class SpecialCollectionCell: UICollectionViewCell {
    
    
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var rsLbl: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellView.layer.shadowRadius = 4

    }
    @IBAction func favBtnPressed(_ sender: Any) {
        
        if favImg.image == UIImage(named: "like") {
                favImg.image = UIImage(named: "heart (4)")
            } else {
                favImg.image = UIImage(named: "like")
            }
    }
}
