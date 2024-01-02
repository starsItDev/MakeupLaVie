//
//  ReviewTableViewCell.swift
//  TabBar
//
//  Created by Rao Ahmad on 08/08/2023.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var reviewTableImage: UIImageView!
    
    @IBOutlet weak var reviewItemNameLbl: UILabel!
    
    @IBOutlet weak var reviewPriceNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
