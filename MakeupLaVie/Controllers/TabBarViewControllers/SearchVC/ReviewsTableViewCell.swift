//
//  ReviewsTableViewCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 13/03/2024.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageReviewView: UIImageView!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
