//
//  CheckoutViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 02/08/2023.
//

import UIKit

struct Person {
    var Address: String
    var firstName: String
    var lastName: String
    var number: String
    var country: String
    var province: String
    var city: String
    var postcode: String
    var AddressOne: String
    var AddressTwo: String
}
struct ExistingAddress{
    var Address: String
}

//protocol CheckoutViewControllerDelegate: AnyObject {
//    func didSelectShippingButton(changeLineColor: Bool)
//}

class CheckoutViewController: UIViewController, UITextFieldDelegate{
    
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
    
    // MARK: - Variables
    var params = [String: Any]()
    var selectedTextField: UITextField = UITextField()
    var addressPicker = UIPickerView()
    let countryPicker = UIPickerView()
    let statePicker = UIPickerView()
    var billingPeopleArr: [Person] = []
    var shippingPeopleArr: [Person] = []
    var selectedAddress: String?
    var selectedCountry: String?
    var selectedProvince: String?
    var existAddrArr = [String]()
    var countries = [String]()
    var provinces = [String]()
    
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
    @IBAction func unCheckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setImage(UIImage(named: "tick"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "unCheck"), for: .normal)
        }
    }
    @IBAction func shippingButton(_ sender: UIButton) {
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
            paramDic["billing"] = params
            postCheckoutAPICall(params: paramDic)
            
        }
    }
    
    @IBAction func cartBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkOutBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func checkOutDetailsAPI(){
        let url = base_url + "checkout"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary{
                    if let addresses = body["addresses"]?.array {
                        for i in addresses{
                            let type = i["type"].stringValue
                            if type == "billing"{
                                billingId = i["id"].intValue
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
                                self.existAddrArr.append(existAddr)
                                //self.countries.append(i["country"].stringValue)
                                //self.provinces.append(i["state"].stringValue)
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
    
    func postCheckoutAPICall(params: [String:Any]){
        let url = base_url + "checkout/billing"
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if response["body"].dictionary != nil {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShippingViewController") as? ShippingViewController {
                        if !self.billingPeopleArr.isEmpty{
                            vc.billingData = self.billingPeopleArr.last
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    //                    vc.shippingPeopleArr = self.shippingPeopleArr
                    //                    vc.showData()
                    //                    self.delegate?.didSelectShippingButton(changeLineColor: true)
                }
            }
        }
        //self.delegate?.didSelectShippingButton(changeLineColor: true) //only for testing
    }
}

// MARK: - Extension PickerView
extension CheckoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == addressPicker{
            return billingPeopleArr.count + 1
        }
        else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == addressPicker{
            if row == 0 {
                return "App new Address"
            } else {
                return billingPeopleArr[row - 1].Address
            }
        }
        else if pickerView == countryPicker{
            return billingPeopleArr[row].country
        }
        else if pickerView == statePicker{
            return billingPeopleArr[row].province
        }
        else{
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addressPicker {
            if row == 0 {
                existingAddressTxt.text = "App New Address"
                firstNameTxt.text = ""
                lastNameTxt.text = ""
                phoneNoTxt.text = ""
                cityTxt.text = ""
                postCodeTxt.text = ""
                address1Txt.text = ""
                address2Txt.text = ""
            } else {
                let selectedTag = pickerView.tag
                guard selectedTag < billingPeopleArr.count
                else {
                    return
                }
                self.existingAddressTxt.text = billingPeopleArr[row - 1].Address
                self.firstNameTxt.text = billingPeopleArr[row - 1].firstName
                self.lastNameTxt.text = billingPeopleArr[row - 1].lastName
                self.phoneNoTxt.text = billingPeopleArr[row - 1].number
                self.countryTxt.text = billingPeopleArr[row - 1].country
                self.stateTxt.text = billingPeopleArr[row - 1].province
                self.cityTxt.text = billingPeopleArr[row - 1].city
                self.postCodeTxt.text = billingPeopleArr[row - 1].postcode
                self.address1Txt.text = billingPeopleArr[row - 1].AddressOne
                self.address2Txt.text = billingPeopleArr[row - 1].AddressTwo
            }
        }
        else if pickerView == countryPicker{
            self.countryTxt.text = billingPeopleArr[row].country
        }
        else if pickerView == statePicker{
            self.stateTxt.text = billingPeopleArr[row].province
        }
    }
}



