//
//  collectioncell.swift
//  OnlineStore
//
//  Created by Musharraf on 04/11/2020.
//  Copyright © 2020 Musharraf. All rights reserved.
//

import UIKit
import Cosmos

protocol addtoWishlistProtocol {
    func didpressedHeart(tag: Int)
}

class collectioncell: UICollectionViewCell {
    //Used in Slider
    @IBOutlet weak var myimage: UIImageView!
    //Used in Categories
    @IBOutlet weak var catagoryimage: UIImageView!
    @IBOutlet weak var catagorynames: UILabel!
    //Used in CollectionCell
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var shadowview: UIView!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var addToCartBtn : UIButton!
    @IBOutlet weak var featureLbl: UILabel!
    @IBOutlet weak var newPriceLbl: UILabel!
    @IBOutlet weak var oldPriceLbl: UILabel!
    @IBOutlet weak var cosmosRating: CosmosView!
    //Used in brands
    @IBOutlet weak var brandimg: UIImageView!
    @IBOutlet weak var brandcell: UIView!
    var delegate: addtoWishlistProtocol?
    
    override func awakeFromNib() {
        if brandimg != nil{
            brandimg.layer.cornerRadius = 10
            brandimg.clipsToBounds = true
            brandimg.layer.shadowRadius = 10
        }
        if shadowview != nil{
            shadowview.backgroundColor = UIColor.white
            shadowview.layer.cornerRadius = 10
            shadowview.layer.shadowRadius = 10
            shadowview.layer.shadowOpacity = 0.3
            shadowview.layer.shadowColor = UIColor.black.cgColor
            shadowview.layer.shadowOffset = .zero
        }
    }
    @IBAction func butnclk(_ sender: UIButton){
        let dic  = ["tag":"\(self.tag)"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: dic)
    }
}

