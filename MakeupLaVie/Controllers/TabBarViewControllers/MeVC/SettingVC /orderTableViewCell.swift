//
//  orderTableViewCell.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 10/01/2024.
//

import UIKit

class orderTableViewCell: UITableViewCell {

    @IBOutlet weak var myOrderImage: UIImageView!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderQuantity: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
