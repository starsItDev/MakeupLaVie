//
//  TabBarVC.swift
//  MakeupLaVie
//
//  Created by Apple on 14/07/2023.
//

import UIKit


class TabBarVC: UITabBarController {
    
    @IBOutlet weak var homeTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if homeTabBar.selectedItem?.title == "Me"{
            if UserInfo.shared.isUserLoggedIn == false{
                let vc = storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? LoginNavigationController
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
        }
    }
}
