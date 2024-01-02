//
//  utilityFunctions.swift
//  MakeupLaVie
//
//  Created by Apple on 18/07/2023.
//

import Foundation
import UIKit

public class utilityFunctions{
    
   public static func showAlertWithTitle(title: String, withMessage: String, withNavigation: UIViewController) {
        
        let alertController : UIAlertController = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertController.Style.alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .default){
            ACTION -> Void in
        }
        alertController.addAction(cancelAction)
        withNavigation.present(alertController, animated: true, completion: nil)
    }
}
