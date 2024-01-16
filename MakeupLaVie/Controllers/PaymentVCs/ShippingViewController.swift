//
//  ShippingViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 07/08/2023.
//

import UIKit

class ShippingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var existingAddressTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var phoneNoTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var postCodeTxt: UITextField!
    @IBOutlet weak var address1Txt: UITextField!
    @IBOutlet weak var address2Txt: UITextField!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var fieldsStackView: UIStackView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    var params = [String: Any]()
    var addressPicker = UIPickerView()
    let countryPicker = UIPickerView()
    let statePicker = UIPickerView()
    var selectedAddress: String?
    var selectedCountry: String?
    var selectedProvince: String?
    var shippingPeopleArr: [Person] = []
    var billingData: Person?
    var billingPeopleArr: [Person] = []
    var billingAddress = [String]()
    var Address = [String]()
    var countries = [String]()
    var provinces = [String]()
    var totalAmount = String()
    var sameAddress = false
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOutDetailsAPI()
        addressPicker.delegate = self
        countryPicker.delegate = self
        statePicker.delegate = self
        statePicker.dataSource = self
        existingAddressTxt.inputView = addressPicker
        countryTxt.inputView = countryPicker
        stateTxt.inputView = statePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - HelperFunctions
    @objc func handleTap() {
        view.endEditing(true)
        dismissPickers()
    }
    func dismissPickers() {
        existingAddressTxt.resignFirstResponder()
        countryTxt.resignFirstResponder()
        stateTxt.resignFirstResponder()
    }
    @IBAction func backToBilling(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkOutBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func paymentButton(_ sender: UIButton) {
        if sameAddress == true{
            params["first_name"] = billingData?.firstName
            params["last_name"] = billingData?.lastName
            params["phone"] = billingData?.number
            params["country"] = billingData?.country
            params["state"] = billingData?.province
            params["city"] = billingData?.city
            params["zip"] = billingData?.postcode
            params["address_1"] = billingData?.AddressOne
            params["address_2"] = billingData?.AddressTwo
            params["default"] = 1
            var paramDic = [String: Any]()
            paramDic["address_id"] = "1"
            paramDic["shipping"] = params
            postShippingAPICall(params: paramDic)
        }
        else {
            if (existingAddressTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "Existing Address is required", withNavigation: self)
                return
            }
            if (firstNameTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "First Name is required", withNavigation: self)
                return
            }
            if (lastNameTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "Last Name is required", withNavigation: self)
                return
            }
            if (phoneNoTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "Phone Number is required", withNavigation: self)
                return
            }
            if (phoneNoTxt.text?.count ?? 0 < 6) {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "Phone Number should be at least six characters", withNavigation: self)
                return
            }
            if (countryTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "Country is required", withNavigation: self)
                return
            }
            if (stateTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "State is required", withNavigation: self)
                return
            }
            if (cityTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "City Name is required", withNavigation: self)
                return
            }
            if (postCodeTxt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "Postcode/Zip Name is required", withNavigation: self)
                return
            }
            if (address1Txt?.text?.isEmpty)! {
                utilityFunctions.showAlertWithTitle(title: "", withMessage: "Address 1 is required", withNavigation: self)
                return
            }
            else{
                params["first_name"] = firstNameTxt.text
                params["last_name"] = lastNameTxt.text
                params["phone"] = phoneNoTxt.text
                params["country"] = countryTxt.text
                params["state"] = stateTxt.text
                params["city"] = cityTxt.text
                params["zip"] = postCodeTxt.text
                params["address_1"] = address1Txt.text
                params["address_2"] = address2Txt.text
                params["default"] = 1
                var paramDic = [String: Any]()
                paramDic["address_id"] = "1"
                paramDic["shipping"] = params
                postShippingAPICall(params: paramDic)
                
            }
        }
    }
    @IBAction func unCheckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.sameAddress = true
            sender.setImage(UIImage(named: "tick"), for: .normal)
            fieldsStackView.isHidden = true
            if let billingData = billingData {
                existingAddressTxt.text = "\(billingData.firstName) \(billingData.lastName) (\(billingData.AddressOne))"
                self.firstNameTxt.text = billingData.firstName
                self.lastNameTxt.text = billingData.lastName
                self.phoneNoTxt.text = billingData.number
                self.postCodeTxt.text = billingData.postcode
                self.address1Txt.text = billingData.AddressOne
                self.address2Txt.text = billingData.AddressTwo
                self.countryTxt.text = billingData.country
                self.stateTxt.text = billingData.province
                self.cityTxt.text = billingData.city
            }
            existingAddressTxt.isUserInteractionEnabled = false
            existingAddressTxt.textColor = .lightGray
            stackHeight.constant = 0
        } else {
            self.sameAddress = false
            sender.setImage(UIImage(named: "unCheck"), for: .normal)
            fieldsStackView.isHidden = false
            if Address.isEmpty{
                existingAddressTxt.text = "App new address"
                firstNameTxt.text = ""
                lastNameTxt.text = ""
                phoneNoTxt.text = ""
                postCodeTxt.text = ""
                address1Txt.text = ""
                address2Txt.text = ""
                cityTxt.text = ""
            } else {
                existingAddressTxt.text = self.Address.last
                firstNameTxt.text = self.shippingPeopleArr.last?.firstName
                lastNameTxt.text = self.shippingPeopleArr.last?.lastName
                phoneNoTxt.text = self.shippingPeopleArr.last?.number
                postCodeTxt.text = self.shippingPeopleArr.last?.postcode
                address1Txt.text = self.shippingPeopleArr.last?.AddressOne
                address2Txt.text = self.shippingPeopleArr.last?.AddressTwo
                cityTxt.text = self.shippingPeopleArr.last?.city
            }
            existingAddressTxt.isUserInteractionEnabled = true
            existingAddressTxt.textColor = .black
            stackHeight.constant = 556
        }
    }
    func checkOutDetailsAPI(){
        let url = base_url + "checkout"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary{
                    self.totalAmount = body["total"]?.string ?? ""
                    if let addresses = body["addresses"]?.array {
                        for i in addresses{
                            let type = i["type"].stringValue
                            if type == "shipping"{
                                shippingId = i["id"].intValue
                                let firstName = i["first_name"].stringValue
                                let lastName = i["last_name"].stringValue
                                let phoneNo = i["phone"].stringValue
                                let zipCode = i["zip"].stringValue
                                let address1 = i["address_1"].stringValue
                                let address2 = i["address_2"].stringValue
                                let country = i["country"].stringValue
                                let state = i["state"].stringValue
                                let city = i["city"].stringValue
                                let existAddr = "\(firstName)\(lastName)(\(address1))"
                                self.Address.append(existAddr)
                                self.countries.append(i["country"].stringValue)
                                self.provinces.append(i["state"].stringValue)
                                self.existingAddressTxt.text = existAddr
                                self.firstNameTxt.text = firstName
                                self.lastNameTxt.text = lastName
                                self.phoneNoTxt.text = phoneNo
                                self.postCodeTxt.text = zipCode
                                self.address1Txt.text = address1
                                self.address2Txt.text = address2
                                self.countryTxt.text = country
                                self.stateTxt.text = state
                                self.cityTxt.text = city
                                
                                let person = Person(Address: existAddr, firstName: firstName, lastName: lastName, number: phoneNo, country: country, province: state, city: city, postcode: zipCode, AddressOne: address1, AddressTwo: address2)
                                self.shippingPeopleArr.append(person)
                            }
                            else if type == "billing" {
                                shippingId = i["id"].intValue
                                let firstName = i["first_name"].stringValue
                                let lastName = i["last_name"].stringValue
                                let phoneNo = i["phone"].stringValue
                                let zipCode = i["zip"].stringValue
                                let address1 = i["address_1"].stringValue
                                let address2 = i["address_2"].stringValue
                                let country = i["country"].stringValue
                                let state = i["state"].stringValue
                                let city = i["city"].stringValue
                                let existAddr = "\(firstName)\(lastName)(\(address1))"
                                self.billingAddress.append(existAddr)
                                self.countries.append(i["country"].stringValue)
                                self.provinces.append(i["state"].stringValue)
                                let person = Person(Address: existAddr, firstName: firstName, lastName: lastName, number: phoneNo, country: country, province: state, city: city, postcode: zipCode, AddressOne: address1, AddressTwo: address2)
                                self.billingData = person
                                self.billingPeopleArr.append(person)
                            }
                        }
                    }
                }
            }
            else{
                print("Something went wrong")
            }
        }
    }
    
    func postShippingAPICall(params: [String:Any]){
        let url = base_url + "checkout/shipping"
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if response["body"].dictionary != nil{
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
                        if self.totalAmount != ""{
                            vc.totalAmount = self.totalAmount
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Extension PickerView
extension ShippingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == addressPicker{
            return shippingPeopleArr.count + 1
        }
        else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == addressPicker{
            if row == 0 {
                return "App New Address"
            } else {
                return shippingPeopleArr[row - 1].Address
            }
        }
        else if pickerView == countryPicker{
            return shippingPeopleArr[row].country
        }
        else if pickerView == statePicker{
            return shippingPeopleArr[row].province
        }
        else{
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addressPicker{
            if row == 0 {
                existingAddressTxt.text = "App new Address"
                firstNameTxt.text = ""
                lastNameTxt.text = ""
                phoneNoTxt.text = ""
                cityTxt.text = ""
                postCodeTxt.text = ""
                address1Txt.text = ""
                address2Txt.text = ""
            } else {
                let selectedTag = pickerView.tag
                guard selectedTag < shippingPeopleArr.count
                else {
                    return
                }
                self.existingAddressTxt.text = shippingPeopleArr[row - 1].Address
                self.firstNameTxt.text = shippingPeopleArr[row - 1].firstName
                self.lastNameTxt.text = shippingPeopleArr[row - 1].lastName
                self.phoneNoTxt.text = shippingPeopleArr[row - 1].number
                self.countryTxt.text = shippingPeopleArr[row - 1].country
                self.stateTxt.text = shippingPeopleArr[row - 1].province
                self.cityTxt.text = shippingPeopleArr[row - 1].city
                self.postCodeTxt.text = shippingPeopleArr[row - 1].postcode
                self.address1Txt.text = shippingPeopleArr[row - 1].AddressOne
                self.address2Txt.text = shippingPeopleArr[row - 1].AddressTwo
            }
        }
        else if pickerView == countryPicker{
            self.countryTxt.text = shippingPeopleArr[row].country
        }
        else if pickerView == statePicker{
            self.stateTxt.text = shippingPeopleArr[row].province
        }
    }
}


