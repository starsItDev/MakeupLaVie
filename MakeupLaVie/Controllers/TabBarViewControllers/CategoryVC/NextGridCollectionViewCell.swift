//
//  NextGridCollectionViewCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 19/06/2023.
//

import UIKit
import Cosmos

class NextGridCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
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
