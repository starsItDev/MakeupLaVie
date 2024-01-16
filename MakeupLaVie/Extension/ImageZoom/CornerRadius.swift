//
//  CornerRadius.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 16/01/2024.
//

import Foundation
import UIKit

extension UIView {
    
  @IBInspectable  var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
