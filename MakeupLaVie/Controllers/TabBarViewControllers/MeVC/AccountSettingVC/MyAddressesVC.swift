//
//  MyAddressesVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class MyAddressesVC: UIViewController {

    @IBOutlet weak var addressTableView: UITableView!
    var address: [Address] = []
    
    //MARK: - override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
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
                do {
                    let jsonData = try response.rawData()
                    let decoder = JSONDecoder()
                    let myAddressModel = try decoder.decode(AddressResponse.self, from: jsonData)
                    print("Status Code: \(myAddressModel.statusCode)")
                    self.address = myAddressModel.body
                    DispatchQueue.main.async {
                        self.addressTableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else {
                print("Something went wrong")
            }
        }
    }
    @objc func editBtnTapped(sender: UIButton) {
        if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
            vc.isComingFromEdit = true
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
        cell.nameLabel.text = myAddress.city
        cell.numberLabel.text = myAddress.country
        cell.addressLabel.text = myAddress.address1
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

