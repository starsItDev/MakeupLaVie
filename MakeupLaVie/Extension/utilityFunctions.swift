//
//  utilityFunctions.swift
//  MakeupLaVie
//
//  Created by Apple on 18/07/2023.
//

import Foundation
import UIKit
import SystemConfiguration

public class utilityFunctions{
    
   public static func showAlertWithTitle(title: String, withMessage: String, withNavigation: UIViewController) {
        
        let alertController : UIAlertController = UIAlertController(title: title, message: withMessage, preferredStyle: UIAlertController.Style.alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .default){
            ACTION -> Void in
        }
        alertController.addAction(cancelAction)
        withNavigation.present(alertController, animated: true, completion: nil)
    }
    class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            let isReachable = flags == .reachable
            let needsConnection = flags == .connectionRequired
            
            return isReachable && !needsConnection
            
        }
}
