//
//  MyAddressesVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class MyAddressesVC: UIViewController {

    @IBOutlet weak var addressTableView: UITableView!
    var address: [Person] = []
    
    //MARK: - override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myAddressAPI()
    }
    
    //MARK: - Helper Functions
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func myAddressAPI() {
        let urlString = base_url + "user/addresses"
        Networking.instance.getApiCall(url: urlString) { (response, error, statusCode) in
            if error == nil && statusCode == 200 {
                if let body = response["body"].array{
                    for adr in body{
                        let id = adr["id"].intValue
                        let type = adr["type"].stringValue
                        let firstName = adr["first_name"].stringValue
                        let lastName = adr["last_name"].stringValue
                        let phoneNo = adr["phone"].stringValue
                        let zipCode = adr["zip"].stringValue
                        let address1 = adr["address_1"].stringValue
                        let address2 = adr["address_2"].stringValue
                        let country = adr["country"].stringValue
                        let state = adr["state"].stringValue
                        let city = adr["city"].stringValue
                        let existAddr = "\(firstName)\(lastName)(\(address1))"
                        let person = Person(id: id , Address: existAddr, firstName: firstName , lastName: lastName , number: phoneNo , country: country , province: state , city: city , postcode: zipCode , AddressOne: address1 , AddressTwo: address2, addressType: type )
                        self.address.append(person)
                    }
                    
                }
                DispatchQueue.main.async {
                    self.addressTableView.reloadData()
                }
            } else {
                print("Something went wrong")
            }
        }
    }
    @objc func editBtnTapped(sender: UIButton) {
        if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditAddressVC") as? EditAddressVC {
            //vc.isComingFromEdit = true
            vc.billingData = address[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - Extension TableView
extension MyAddressesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressesTableViewCell
        let myAddress = address[indexPath.row]
//      let fullName = "\(myAddress.firstName) \(myAddress.lastName)"
        cell.addressOneLbl.text = "\(myAddress.AddressOne), \(myAddress.city), \(myAddress.province)"
        if !myAddress.AddressTwo.isEmpty{
            cell.addressTwoLbl.text = "\(myAddress.AddressTwo), \(myAddress.city), \(myAddress.province)"
        }
        //cell.addressLabel.text = myAddress.AddressOne
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editBtnTapped(sender:)), for: .touchUpInside)
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}
