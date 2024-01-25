//  MeVC.swift
//  MakeupLaVie
//  Created by StarsDev on 17/04/2023.

import UIKit

class MeVC: UIViewController {
    
    @IBOutlet var nameLbl: UILabel!
    
    var array:[String] = ["Update Profile","Change Password","My Addresses", "Terms And Conditions","Privacy Policy","Help","Logout"]
    var picArr = [#imageLiteral(resourceName: "ic_user_edit"), #imageLiteral(resourceName: "ic_password__3_"), #imageLiteral(resourceName: "ic_address"), #imageLiteral(resourceName: "ic_terms_and_conditions"), #imageLiteral(resourceName: "ic_privacy"), #imageLiteral(resourceName: "ic_customer_service"), #imageLiteral(resourceName: "ic_logout")]
    @IBOutlet var meCVView: UIView!
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getapiCall()
        meCVView.layer.shadowColor = UIColor.systemGray4.cgColor
        meCVView.layer.shadowOpacity = 1
        meCVView.layer.shadowOffset = .zero
        meCVView.layer.shadowRadius = 3
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.nameLbl.text = "\(UserInfo.shared.firstName) \(UserInfo.shared.lastName)"
        if !UserInfo.shared.isUserLoggedIn{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        self.tabBarController?.tabBar.isHidden = false
    }
 
    @IBAction func orderBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OrderVC") as? OrderVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func VoucherBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VouchersVC") as? VouchersVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func WishListBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WishListVC") as? WishListVC
        vc?.isWishList = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func MessageBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MassageVC") as? MassageVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func ReviewBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyReviewsVC") as? MyReviewsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func NotificationBtn(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension MeVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",for: indexPath) as! MeVCTableView
        cell.myLabel.text = array[indexPath.row]
        cell.myImg.image = picArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let uname:UpdateProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(uname, animated: true)
        }
        else if indexPath.row == 1{
            let VC :ChangePasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 2{
            let VC :MyAddressesVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAddressesVC") as! MyAddressesVC
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if indexPath.row == 6{
            UserInfo.logOut()
            //TokenService.tokenInstance.removeToken()
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if indexPath.row == 3{
            if let url = URL(string: "https://app.ecommercep.com/api/help/terms"){
                UIApplication.shared.open(url)
            }
        }
        else if indexPath.row == 4{
            if let url = URL(string: "https://app.ecommercep.com/api/help/privacy"){
                UIApplication.shared.open(url)
            }
        }
        else if indexPath.row == 5{
            if let url = URL(string: "https://app.ecommercep.com/help/support"){
                UIApplication.shared.open(url)
            }
        }
    }
}
