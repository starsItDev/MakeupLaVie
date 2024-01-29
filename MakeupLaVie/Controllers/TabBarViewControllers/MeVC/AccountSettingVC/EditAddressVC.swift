//
//  EditAddressVC.swift
//  MakeupLaVie
//
//  Created by Apple on 25/01/2024.
//

import UIKit

class EditAddressVC: UIViewController {

    //MARK: - Outlets
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
    
    //MARK: - Variables
    var billingData: Person?
    var params = [String: Any]()
    let statePicker = UIPickerView()
    var addressType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.delegate = self
        statePicker.dataSource = self
        stateTxt.inputView = statePicker
        showPersonData()
    }
    
    func showPersonData(){
        billingId = billingData?.id ?? 0
        self.existingAddressTxt.text = billingData?.Address
        self.existingAddressTxt.isUserInteractionEnabled = false
        self.firstNameTxt.text = billingData?.firstName
        self.firstNameTxt.isUserInteractionEnabled = false
        self.lastNameTxt.text = billingData?.lastName
        self.lastNameTxt.isUserInteractionEnabled = false
        self.phoneNoTxt.text = billingData?.number
        self.phoneNoTxt.isUserInteractionEnabled = false
        self.postCodeTxt.text = billingData?.postcode
        self.address1Txt.text = billingData?.AddressOne
        self.address2Txt.text = billingData?.AddressTwo
        self.countryTxt.text = billingData?.country
        self.countryTxt.isUserInteractionEnabled = false
        self.stateTxt.text = billingData?.province
        self.cityTxt.text = billingData?.city
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateAddressBtnTapped(_ sender: Any) {
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
            paramDic["address_id"] = "\(billingData?.id ?? 0)"
            if billingData?.addressType == "billing"{
                paramDic["billing"] = params
            }
            else{
                paramDic["shipping"] = params
            }
            postCheckoutAPICall(params: paramDic)
        }
    }
    
    func postCheckoutAPICall(params: [String:Any]){
        var url = String()
        if billingData?.addressType == "billing"{
            url = base_url + "checkout/billing"
        }
        else{
            url = base_url + "checkout/shipping"
        }
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if response["body"].dictionary != nil {
                    let body = response["body"].dictionary
                    let type = body?["type"]?.stringValue
                    self.navigationController?.popViewController(animated: true)
//                    if type == "billing"{
//                        let id = body?["id"]?.intValue
//                        billingId = id ?? 0
//                        let firstName = body?["first_name"]?.stringValue ?? ""
//                        let lastName = body?["last_name"]?.stringValue ?? ""
//                        let phoneNo = body?["phone"]?.stringValue
//                        let zipCode = body?["zip"]?.stringValue
//                        let address1 = body?["address_1"]?.stringValue ?? ""
//                        let address2 = body?["address_2"]?.stringValue
//                        let country = body?["country"]?.stringValue
//                        let state = body?["state"]?.stringValue
//                        let city = body?["city"]?.stringValue
//                        let existAddr = "\(firstName)\(lastName)(\(address1))"
//                        let person = Person(id: id ?? 0, Address: existAddr, firstName: firstName , lastName: lastName , number: phoneNo ?? "", country: country ?? "", province: state ?? "", city: city ?? "", postcode: zipCode ?? "", AddressOne: address1 , AddressTwo: address2 ?? "", addressType: type ?? "")
//                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShippingViewController") as? ShippingViewController {
//
//                            vc.billingData = person
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
                }
            }
        }
    }
    
}

extension EditAddressVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == addressPicker{
//            return billingPeopleArr.count + 1
//        }
//        else if pickerView == countryPicker{
//            return countriesArr.count
//        }
        if pickerView == statePicker{
            return provincesArr.count
        }
        else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == addressPicker{
//            if row == 0 {
//                return "App new Address"
//            } else {
//                return billingPeopleArr[row - 1].Address
//            }
//        }
//        else if pickerView == countryPicker{
//            return countriesArr[row]
//        }
        if pickerView == statePicker{
            return provincesArr[row]
        }
        else{
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == addressPicker {
//            if row == 0 {
//                existingAddressTxt.text = "App New Address"
//                self.addressId = 0
//                firstNameTxt.text = ""
//                lastNameTxt.text = ""
//                phoneNoTxt.text = ""
//                cityTxt.text = ""
//                postCodeTxt.text = ""
//                address1Txt.text = ""
//                address2Txt.text = ""
//            } else {
//                let selectedTag = pickerView.tag
//                guard selectedTag < billingPeopleArr.count
//                else {
//                    return
//                }
//
//                self.addressId = billingPeopleArr[row - 1].id
//                billingId = addressId
//                self.existingAddressTxt.text = billingPeopleArr[row - 1].Address
//                self.firstNameTxt.text = billingPeopleArr[row - 1].firstName
//                self.lastNameTxt.text = billingPeopleArr[row - 1].lastName
//                self.phoneNoTxt.text = billingPeopleArr[row - 1].number
//                self.countryTxt.text = billingPeopleArr[row - 1].country
//                self.stateTxt.text = billingPeopleArr[row - 1].province
//                self.cityTxt.text = billingPeopleArr[row - 1].city
//                self.postCodeTxt.text = billingPeopleArr[row - 1].postcode
//                self.address1Txt.text = billingPeopleArr[row - 1].AddressOne
//                self.address2Txt.text = billingPeopleArr[row - 1].AddressTwo
//            }
//        }
//        else if pickerView == countryPicker{
//            self.countryTxt.text = countriesArr[row]
//        }
        if pickerView == statePicker{
            self.stateTxt.text = provincesArr[row]
        }
    }
}
