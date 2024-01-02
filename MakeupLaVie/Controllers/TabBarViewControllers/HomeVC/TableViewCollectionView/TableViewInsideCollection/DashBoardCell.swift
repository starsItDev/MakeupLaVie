//
//  DashBoardCell.swift
//  OnlineStore
//
//  Created by Musharraf on 04/11/2020.
//  Copyright © 2020 Musharraf. All rights reserved.
//

import UIKit

class DashBoardCell: UITableViewCell {
   // @IBOutlet weak var iconLbl: UIButton!
     @IBOutlet weak var itemname: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
