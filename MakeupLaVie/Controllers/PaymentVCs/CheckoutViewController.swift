//
//  CheckoutViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 02/08/2023.
//

import UIKit

struct Person {
    var id: Int
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
    var addressType: String
}
struct ExistingAddress{
    var Address: String
}

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
    @IBOutlet weak var checkoutLabel: UILabel!
    @IBOutlet weak var updateView: UIView!
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
    //var provinces = [String]()
    //var isComingFromEdit = false
    var addressId = 0
    var billingData: Person?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOutDetailsAPI()
        addressPicker.delegate = self
        countryPicker.delegate = self
        statePicker.delegate = self
        statePicker.dataSource = self
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        phoneNoTxt.delegate = self
        cityTxt.delegate = self
        postCodeTxt.delegate = self
        address1Txt.delegate = self
        address2Txt.delegate = self
        existingAddressTxt.inputView = addressPicker
        countryTxt.inputView = countryPicker
        stateTxt.inputView = statePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
//        if isComingFromEdit {
//            checkoutLabel.text = "Edit Address"
//            updateView.isHidden = false
//        } else {
//            checkoutLabel.text = "Checkout"
//        }
        
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
            if self.addressId == 0{
                paramDic["address_id"] = "1"
                billingId = 1
            }
            else{
                paramDic["address_id"] = "\(addressId)"
                billingId = addressId
            }
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
    @IBAction func updateAddressBtn(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAddressesVC") as? MyAddressesVC {
            
            self.navigationController?.popViewController(animated: true)
        }
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
                                let id = i["id"].intValue
                                billingId = id
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
//                                self.existAddrArr.append(existAddr)
//                                //self.countries.append(i["country"].stringValue)
//                                //self.provinces.append(i["state"].stringValue)
//                                self.existingAddressTxt.text = existAddr
//                                self.firstNameTxt.text = firstName
//                                self.lastNameTxt.text = lastName
//                                self.phoneNoTxt.text = phoneNo
//                                self.postCodeTxt.text = zipCode
//                                self.address1Txt.text = address1
//                                self.address2Txt.text = address2
//                                self.countryTxt.text = country
//                                self.stateTxt.text = state
//                                self.cityTxt.text = city
                                
                                let person = Person(id: id, Address: existAddr, firstName: firstName, lastName: lastName, number: phoneNo, country: country, province: state, city: city, postcode: zipCode, AddressOne: address1, AddressTwo: address2, addressType: type)
                                self.billingPeopleArr.append(person)
                            }
                        }
                    }
                }
            }
            else{
                print("Something went wrong")
            }
            self.showData()
        }
    }
    
    func showData(){
//        if isComingFromEdit{
//            checkoutLabel.text = "Edit Address"
//            updateView.isHidden = false
//            billingId = billingData?.id ?? 0
//            self.existingAddressTxt.text = billingData?.Address
//            self.existingAddressTxt.isUserInteractionEnabled = false
//            self.firstNameTxt.text = billingData?.firstName
//            self.firstNameTxt.isUserInteractionEnabled = false
//            self.lastNameTxt.text = billingData?.lastName
//            self.lastNameTxt.isUserInteractionEnabled = false
//            self.phoneNoTxt.text = billingData?.number
//            self.phoneNoTxt.isUserInteractionEnabled = false
//            self.postCodeTxt.text = billingData?.postcode
//            self.address1Txt.text = billingData?.AddressOne
//            self.address2Txt.text = billingData?.AddressTwo
//            self.countryTxt.text = billingData?.country
//            self.countryTxt.isUserInteractionEnabled = false
//            self.stateTxt.text = billingData?.province
//            self.cityTxt.text = billingData?.city
//        }
//        else{
            checkoutLabel.text = "Checkout"
            self.existingAddressTxt.text = billingPeopleArr.last?.Address
            self.firstNameTxt.text = billingPeopleArr.last?.firstName
            self.lastNameTxt.text = billingPeopleArr.last?.lastName
            self.phoneNoTxt.text = billingPeopleArr.last?.number
            self.postCodeTxt.text = billingPeopleArr.last?.postcode
            self.address1Txt.text = billingPeopleArr.last?.AddressOne
            self.address2Txt.text = billingPeopleArr.last?.AddressTwo
            self.countryTxt.text = billingPeopleArr.last?.country
            self.stateTxt.text = billingPeopleArr.last?.province
            self.cityTxt.text = billingPeopleArr.last?.city
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
        //}
    }
    
    func postCheckoutAPICall(params: [String:Any]){
        let url = base_url + "checkout/billing"
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if response["body"].dictionary != nil {
                    let body = response["body"].dictionary
                    let type = body?["type"]?.stringValue
                    if type == "billing"{
                        let id = body?["id"]?.intValue
                        billingId = id ?? 0
                        let firstName = body?["first_name"]?.stringValue ?? ""
                        let lastName = body?["last_name"]?.stringValue ?? ""
                        let phoneNo = body?["phone"]?.stringValue
                        let zipCode = body?["zip"]?.stringValue
                        let address1 = body?["address_1"]?.stringValue ?? ""
                        let address2 = body?["address_2"]?.stringValue
                        let country = body?["country"]?.stringValue
                        let state = body?["state"]?.stringValue
                        let city = body?["city"]?.stringValue
                        let existAddr = "\(firstName)\(lastName)(\(address1))"
                        let person = Person(id: id ?? 0, Address: existAddr, firstName: firstName , lastName: lastName , number: phoneNo ?? "", country: country ?? "", province: state ?? "", city: city ?? "", postcode: zipCode ?? "", AddressOne: address1 , AddressTwo: address2 ?? "", addressType: type ?? "")
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShippingViewController") as? ShippingViewController {

                            vc.billingData = person
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
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
        else if pickerView == countryPicker{
            return countriesArr.count
        }
        else if pickerView == statePicker{
            return provincesArr.count
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
            return countriesArr[row]
        }
        else if pickerView == statePicker{
            return provincesArr[row]
        }
        else{
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addressPicker {
            if row == 0 {
                existingAddressTxt.text = "App New Address"
                self.addressId = 0
                firstNameTxt.text = ""
                lastNameTxt.text = ""
                phoneNoTxt.text = ""
                cityTxt.text = ""
                postCodeTxt.text = ""
                address1Txt.text = ""
                address2Txt.text = ""
                self.existingAddressLbl.isHidden = false
                self.firstNameLbl.isHidden = true
                self.lastNameLbl.isHidden = true
                self.numberLbl.isHidden = true
                self.countryLbl.isHidden = false
                self.stateLbl.isHidden = false
                self.cityLbl.isHidden = true
                self.postCodeLbl.isHidden = true
                self.addressOneLbl.isHidden = true
                self.addressTwoLbl.isHidden = true
            } else {
                let selectedTag = pickerView.tag
                guard selectedTag < billingPeopleArr.count
                else {
                    return
                }
            
                self.addressId = billingPeopleArr[row - 1].id
                billingId = addressId
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
                self.existingAddressLbl.isHidden = false
                self.firstNameLbl.isHidden = false
                self.lastNameLbl.isHidden = false
                self.numberLbl.isHidden = false
                self.countryLbl.isHidden = false
                self.stateLbl.isHidden = false
                self.cityLbl.isHidden = false
                self.postCodeLbl.isHidden = false
                self.addressOneLbl.isHidden = false
                self.addressTwoLbl.isHidden = false
            }
        }
        else if pickerView == countryPicker{
            self.countryTxt.text = countriesArr[row]
        }
        else if pickerView == statePicker{
            self.stateTxt.text = provincesArr[row]
        }
    }
}

extension CheckoutViewController: UITextViewDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showLabel(for: textField)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //if textField.text?.isEmpty ?? false {
        hideLabel(for: textField)
        //}
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
