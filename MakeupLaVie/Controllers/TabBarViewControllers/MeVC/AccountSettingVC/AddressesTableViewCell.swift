//
//  AddressesTableViewCell.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 19/01/2024.
//

import UIKit

class AddressesTableViewCell: UITableViewCell {

    @IBOutlet weak var addressOneLbl: UILabel!
    @IBOutlet weak var addressTwoLbl: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
