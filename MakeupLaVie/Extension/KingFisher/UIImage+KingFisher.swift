//
//  UIImage+KingFisher.swift
//  MakeupLaVie
//
//  Created by StarsDev on 23/05/2023.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func setImage(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: resource, placeholder: UIImage(named: "placeholder_product"))
    }
}
