//
//  CategoriesNextCVCollectionView.swift
//  MakeupLaVie
//
//  Created by StarsDev on 05/06/2023.
//

import UIKit
import Cosmos

class CategoriesNextCVCollectionView: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var rsLbl: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellView.layer.shadowRadius = 4
    }
    @IBAction func favBtnPressed(_ sender: Any) {
//        if favImg.image == UIImage(named: "like") {
//            if traitCollection.userInterfaceStyle == .dark {
//                favImg.image = UIImage(systemName: "heart")
//                favImg.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            } else {
//                favImg.image = UIImage(systemName: "heart")
//                favImg.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            }
//        } else {
//            favImg.image = UIImage(systemName: "heart.fill")
//            favImg.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
//        }
    }
}
