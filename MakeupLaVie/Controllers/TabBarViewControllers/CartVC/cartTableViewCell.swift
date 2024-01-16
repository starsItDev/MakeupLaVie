//
//  cartTableViewCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 14/06/2023.
//

import UIKit

class cartTableViewCell: UITableViewCell ,UITableViewDelegate {
    
    weak var delegate: CartTableViewCellDelegate?
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var quantityLb: UILabel!
    @IBOutlet weak var dislbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    var count = 1
    var selectedResponseID: Int?
    private var responseID: Int?
   
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonView.layer.borderColor = UIColor.systemGray.cgColor
        buttonView.layer.borderWidth = 1.0
        buttonView.layer.cornerRadius = 8.0
    }
}

