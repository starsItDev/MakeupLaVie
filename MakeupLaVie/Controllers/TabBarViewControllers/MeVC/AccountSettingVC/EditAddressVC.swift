//
//  EditAddressVC.swift
//  MakeupLaVie
//
//  Created by Apple on 25/01/2024.
//

import UIKit

class EditAddressVC: UIViewController, UITextFieldDelegate {

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
    @IBOutlet weak var existingAddressLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var postCodeLbl: UILabel!
    @IBOutlet weak var addressOneLbl: UILabel!
    @IBOutlet weak var addressTwoLbl: UILabel!
    
    //MARK: - Variables
    var billingData: Person?
    var params = [String: Any]()
    let statePicker = UIPickerView()
    var addressType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        phoneNoTxt.delegate = self
        cityTxt.delegate = self
        postCodeTxt.delegate = self
        address1Txt.delegate = self
        address2Txt.delegate = self
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
        let isExistingAddressEmpty = existingAddressTxt.text?.isEmpty ?? false
        let isFirstNameEmpty = firstNameTxt.text?.isEmpty ?? false
        let isLastNameEmpty = lastNameTxt.text?.isEmpty ?? false
        let isPhoneNoEmpty = phoneNoTxt.text?.isEmpty ?? false
        let isCountryEmpty = countryTxt.text?.isEmpty ?? false
        let isStateEmpty = stateTxt.text?.isEmpty ?? false
        let isCityEmpty = cityTxt.text?.isEmpty ?? false
        let isPostCodeEmpty = postCodeTxt.text?.isEmpty ?? false
        let isAddress1Empty = address1Txt.text?.isEmpty ?? false
        let isAddress2Empty = address2Txt.text?.isEmpty ?? false
        existingAddressLbl.isHidden = isExistingAddressEmpty
        firstNameLbl.isHidden = isFirstNameEmpty
        lastNameLbl.isHidden = isLastNameEmpty
        numberLbl.isHidden = isPhoneNoEmpty
        countryLbl.isHidden = isCountryEmpty
        stateLbl.isHidden = isStateEmpty
        cityLbl.isHidden = isCityEmpty
        postCodeLbl.isHidden = isPostCodeEmpty
        addressOneLbl.isHidden = isAddress1Empty
        addressTwoLbl.isHidden = isAddress2Empty
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

extension EditAddressVC: UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showLabel(for: textField)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideLabel(for: textField)
    }
    func showLabel(for textField: UITextField) {
        switch textField {
        case existingAddressTxt:
            existingAddressLbl.isHidden = false
            existingAddressTxt.layer.borderWidth = 1
            existingAddressTxt.layer.borderColor = UIColor.red.cgColor
            existingAddressTxt.borderStyle = .roundedRect
        case firstNameTxt:
            firstNameLbl.isHidden = false
            firstNameTxt.layer.borderWidth = 1
            firstNameTxt.layer.borderColor = UIColor.red.cgColor
            firstNameTxt.borderStyle = .roundedRect
        case lastNameTxt:
            lastNameLbl.isHidden = false
            lastNameTxt.layer.borderWidth = 1
            lastNameTxt.layer.borderColor = UIColor.red.cgColor
            lastNameTxt.borderStyle = .roundedRect
        case phoneNoTxt:
            numberLbl.isHidden = false
            phoneNoTxt.layer.borderWidth = 1
            phoneNoTxt.layer.borderColor = UIColor.red.cgColor
            phoneNoTxt.borderStyle = .roundedRect
        case countryTxt:
            countryLbl.isHidden = false
            countryTxt.layer.borderWidth = 1
            countryTxt.layer.borderColor = UIColor.red.cgColor
            countryTxt.borderStyle = .roundedRect
        case stateTxt:
            stateLbl.isHidden = false
            stateTxt.layer.borderWidth = 1
            stateTxt.layer.borderColor = UIColor.red.cgColor
            stateTxt.borderStyle = .roundedRect
        case cityTxt:
            cityLbl.isHidden = false
            cityTxt.layer.borderWidth = 1
            cityTxt.layer.borderColor = UIColor.red.cgColor
            cityTxt.borderStyle = .roundedRect
        case postCodeTxt:
            postCodeLbl.isHidden = false
            postCodeTxt.layer.borderWidth = 1
            postCodeTxt.layer.borderColor = UIColor.red.cgColor
            postCodeTxt.borderStyle = .roundedRect
        case address1Txt:
            addressOneLbl.isHidden = false
            address1Txt.layer.borderWidth = 1
            address1Txt.layer.borderColor = UIColor.red.cgColor
            address1Txt.borderStyle = .roundedRect
        case address2Txt:
            addressTwoLbl.isHidden = false
            address2Txt.layer.borderWidth = 1
            address2Txt.layer.borderColor = UIColor.red.cgColor
            address2Txt.borderStyle = .roundedRect
        default:
            break
        }
    }
    func hideLabel(for textField: UITextField) {
        switch textField {
        case existingAddressTxt:
            if existingAddressTxt.text?.isEmpty ?? false {
                existingAddressLbl.isHidden = true
            }
            existingAddressTxt.layer.borderWidth = 1
            existingAddressTxt.layer.borderColor = UIColor.systemGray5.cgColor
            existingAddressTxt.borderStyle = .roundedRect
        case firstNameTxt:
            if firstNameTxt.text?.isEmpty ?? false {
                firstNameLbl.isHidden = true
            }
            firstNameTxt.layer.borderWidth = 1
            firstNameTxt.layer.borderColor = UIColor.systemGray5.cgColor
            firstNameTxt.borderStyle = .roundedRect
        case lastNameTxt:
            if lastNameTxt.text?.isEmpty ?? false {
                lastNameLbl.isHidden = true
            }
            lastNameTxt.layer.borderWidth = 1
            lastNameTxt.layer.borderColor = UIColor.systemGray5.cgColor
            lastNameTxt.borderStyle = .roundedRect
        case phoneNoTxt:
            if phoneNoTxt.text?.isEmpty ?? false {
                numberLbl.isHidden = true
            }
            phoneNoTxt.layer.borderWidth = 1
            phoneNoTxt.layer.borderColor = UIColor.systemGray5.cgColor
            phoneNoTxt.borderStyle = .roundedRect
        case countryTxt:
            if countryTxt.text?.isEmpty ?? false {
                countryLbl.isHidden = true
            }
            countryTxt.layer.borderWidth = 1
            countryTxt.layer.borderColor = UIColor.systemGray5.cgColor
            countryTxt.borderStyle = .roundedRect
        case stateTxt:
            if stateTxt.text?.isEmpty ?? false {
                stateLbl.isHidden = true
            }
            stateTxt.layer.borderWidth = 1
            stateTxt.layer.borderColor = UIColor.systemGray5.cgColor
            stateTxt.borderStyle = .roundedRect
        case cityTxt:
            if cityTxt.text?.isEmpty ?? false {
                cityLbl.isHidden = true
            }
            cityTxt.layer.borderWidth = 1
            cityTxt.layer.borderColor = UIColor.systemGray5.cgColor
            cityTxt.borderStyle = .roundedRect
        case postCodeTxt:
            if postCodeTxt.text?.isEmpty ?? false {
                postCodeLbl.isHidden = true
            }
            postCodeTxt.layer.borderWidth = 1
            postCodeTxt.layer.borderColor = UIColor.systemGray5.cgColor
            postCodeTxt.borderStyle = .roundedRect
        case address1Txt:
            if address1Txt.text?.isEmpty ?? false {
                addressOneLbl.isHidden = true
            }
            address1Txt.layer.borderWidth = 1
            address1Txt.layer.borderColor = UIColor.systemGray5.cgColor
            address1Txt.borderStyle = .roundedRect
        case address2Txt:
            if address2Txt.text?.isEmpty ?? false {
                addressTwoLbl.isHidden = true
            }
            address2Txt.layer.borderWidth = 1
            address2Txt.layer.borderColor = UIColor.systemGray5.cgColor
            address2Txt.borderStyle = .roundedRect
        default:
            break
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.isEditing) {
            showLabel(for: textField)
        } else {
            hideLabel(for: textField)
        }
        return true
    }
}
