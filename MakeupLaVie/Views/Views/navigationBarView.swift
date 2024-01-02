//
//  navigationBarView.swift
//  MakeupLaVie
//
//  Created by Apple on 17/07/2023.
//

import UIKit

class navigationBarView: UIView {

    @IBOutlet weak var leftNavBtn: UIButton!
    @IBOutlet weak var rightNavBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    //MARK:- Functions

    override var intrinsicContentSize: CGSize {

      return CGSize(width: UIScreen.main.bounds.width, height: 38)

    }
    
}
