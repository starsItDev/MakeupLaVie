//
//  ShippingViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 07/08/2023.
//

import UIKit

struct ShippingPerson: Equatable {
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

    static func == (lhs: ShippingPerson, rhs: ShippingPerson) -> Bool {
        return lhs.Address == rhs.Address &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.number == rhs.number &&
            lhs.country == rhs.country &&
            lhs.province == rhs.province &&
            lhs.city == rhs.city &&
            lhs.postcode == rhs.postcode &&
            lhs.AddressOne == rhs.AddressOne &&
            lhs.AddressTwo == rhs.AddressTwo
    }
}

protocol ShippingViewControllerDelegate: AnyObject {
    func didTapBackToCheckout()
    func didSelectPaymentButton(changeLineColor: Bool)
    func scrollHalf()
    func scrollToInitialPosition()
}

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
    @IBOutlet weak var shippingTableView: UITableView!
    weak var delegate: ShippingViewControllerDelegate?
    @IBOutlet weak var shippingTableViewHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    var params = [String: Any]()
    //var people: [Person] = []
    var addressPicker = UIPickerView()
    let countryPicker = UIPickerView()
    let statePicker = UIPickerView()
    var selectedAddress: String?
    var selectedCountry: String?
    var selectedProvince: String?
    var shippingPeopleArr: [Person] = []
    var billingData: Person?
    var shippingPerson: ShippingPerson?
    var Address = [String]()
    var countries = [String]()
    var provinces = [String]()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
            super.viewDidLoad()
        //checkOutDetailsAPI()
        addressPicker.delegate = self
        countryPicker.delegate = self
        statePicker.delegate = self
        statePicker.dataSource = self
        existingAddressTxt.inputView = addressPicker
        countryTxt.inputView = countryPicker
        stateTxt.inputView = statePicker
        shippingPeopleArr = Array(repeating: Person(Address: "", firstName: "", lastName: "", number: "", country: "", province: "", city: "", postcode: "", AddressOne: "", AddressTwo: ""), count: 10)
        if shippingPerson != nil {
            existingAddressTxt.text = shippingPerson?.Address
            firstNameTxt.text = shippingPerson?.firstName
            lastNameTxt.text = shippingPerson?.lastName
            phoneNoTxt.text = shippingPerson?.number
            countryTxt.text = shippingPerson?.country
            stateTxt.text = shippingPerson?.province
            cityTxt.text = shippingPerson?.city
            postCodeTxt.text = shippingPerson?.postcode
            address1Txt.text = shippingPerson?.AddressOne
            address2Txt.text = shippingPerson?.AddressTwo
            }
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
           view.addGestureRecognizer(tapGesture)
        }
   
    // MARK: - HelperFunctions
    @objc func dismissPicker() {
          for cell in shippingTableView.visibleCells {
          if let checkoutCell = cell as? ShippingTableViewCell {
                 checkoutCell.resetImageRotation()
        }
    }
        view.endEditing(true)
}
    func textFieldDidBeginEditing(_ textField: UITextField) {
           let indexPath = getIndexPath(for: textField)
           let isPickerTextField = indexPath.section == 0 || indexPath.section == 4 || indexPath.section == 5
           if !isPickerTextField {
               textField.layer.borderColor = UIColor.red.cgColor
               textField.layer.borderWidth = 2.0
           if let cell = textField.superview?.superview as? ShippingTableViewCell {
                cell.togglePickerVisibility(true)
        }
    }
}
    func textFieldDidEndEditing(_ textField: UITextField) {
           textField.layer.borderColor = UIColor.gray.cgColor
           textField.layer.borderWidth = 1.0
           if let cell = textField.superview?.superview as? ShippingTableViewCell {
                  cell.togglePickerVisibility(false)
    }
}
    private func getIndexPath(for textField: UITextField) -> IndexPath {
           let point = textField.convert(CGPoint.zero, to: shippingTableView)
           return shippingTableView.indexPathForRow(at: point)!
}
    @IBAction func backToBilling(_ sender: UIButton) {
        delegate?.didTapBackToCheckout()
        delegate?.scrollToInitialPosition()
}
    @IBAction func paymentButton(_ sender: UIButton) {
//        if (existingAddressTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Existing Address is required", withNavigation: self)
//            return
//        }
//        if (firstNameTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "First Name is required", withNavigation: self)
//            return
//        }
//        if (lastNameTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Last Name is required", withNavigation: self)
//            return
//        }
//        if (phoneNoTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Phone Number is required", withNavigation: self)
//            return
//        }
//        if (countryTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Country is required", withNavigation: self)
//            return
//        }
//        if (stateTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "State is required", withNavigation: self)
//            return
//        }
//        if (cityTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "City Name is required", withNavigation: self)
//            return
//        }
//        if (postCodeTxt?.text?.isEmpty)! {
//            utilityFunctions.showAlertWithTitle(title: "", withMessage: "Postcode/Zip Name is required", withNavigation: self)
//            return
//        }
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
    @IBAction func unCheckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
           sender.setImage(UIImage(named: "black"), for: .normal)
           shippingTableView.isHidden = true
           shippingTableViewHeight.constant = 0
}   else {
           sender.setImage(UIImage(named: "unCheck"), for: .normal)
           shippingTableView.isHidden = false
           shippingTableViewHeight.constant = 670
        }
    }
    
//    func showData(){
//
//        for items in shippingPeopleArr{
//            self.Address.append(items.Address)
//            self.countries.append(items.country)
//            self.provinces.append(items.province)
//
//        }
//
//        print(Address)
//        print(countries)
//        print(provinces)
//    }
    
    func checkOutDetailsAPI(){
        let url = base_url + "checkout"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary{
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
                                
                                let person = Person(Address: address1, firstName: firstName, lastName: lastName, number: phoneNo, country: country, province: state, city: city, postcode: zipCode, AddressOne: address1, AddressTwo: address2)
                                self.shippingPeopleArr.append(person)
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
                if let body = response["body"].dictionary{
                    self.delegate?.didSelectPaymentButton(changeLineColor: true)
                    self.delegate?.scrollHalf()
                }
            }
        }
        self.delegate?.didSelectPaymentButton(changeLineColor: true)
        self.delegate?.scrollHalf()
    }
}

    // MARK: - Extension TableView
extension ShippingViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
       return self.shippingPeopleArr.count
}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
}
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 17
}
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footer = UIView()
        footer.backgroundColor = UIColor.white
        return footer
}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:      indexPath) as! ShippingTableViewCell
    let personData = shippingPeopleArr[indexPath.section]
    switch indexPath.section {
    case 0:
        let addressPicker = UIPickerView()
        addressPicker.tag = 0
        addressPicker.delegate = self
        addressPicker.dataSource = self
        cell.cellTextField.inputView = addressPicker
        cell.cellTextField.text = personData.Address
        cell.cellTextField.placeholder = "Existing Address*"
        cell.pickerImage.isHidden = false
        cell.rotateImage(angle: cell.rotationAngle)
    case 1:
        cell.cellTextField.placeholder = "First Name*"
        cell.cellTextField.text = personData.firstName
        cell.pickerImage.isHidden = true
    case 2:
        cell.cellTextField.placeholder = "Last Name*"
        cell.cellTextField.text = personData.lastName
        cell.pickerImage.isHidden = true
    case 3:
        cell.cellTextField.placeholder = "Phone Number*"
        cell.cellTextField.text = personData.number
        cell.pickerImage.isHidden = true
    case 4:
       let countryPicker = UIPickerView()
        countryPicker.tag = 4
        countryPicker.delegate = self
        countryPicker.dataSource = self
        cell.cellTextField.inputView = countryPicker
        cell.cellTextField.text = personData.country
        cell.cellTextField.placeholder = "Country*"
        cell.pickerImage.isHidden = false
        cell.rotateImage(angle: cell.rotationAngle)
    case 5:
       let statePicker = UIPickerView()
        statePicker.tag = 5
        statePicker.delegate = self
        statePicker.dataSource = self
        cell.cellTextField.inputView = statePicker
        cell.cellTextField.text = personData.province
        cell.cellTextField.placeholder = "State / Province*"
        cell.pickerImage.isHidden = false
        cell.rotateImage(angle: cell.rotationAngle)
    case 6:
        cell.cellTextField.placeholder = "City*"
        cell.cellTextField.text = personData.city
        cell.pickerImage.isHidden = true
    case 7:
        cell.cellTextField.placeholder = "Postcode / ZIP*"
        cell.cellTextField.text = personData.postcode
        cell.pickerImage.isHidden = true
    case 8:
        cell.cellTextField.placeholder = "Address 1*"
        cell.cellTextField.text = personData.AddressOne
        cell.pickerImage.isHidden = true
    case 9:
        cell.cellTextField.placeholder = "Address 2*"
        cell.cellTextField.text = personData.AddressTwo
        cell.pickerImage.isHidden = true
    default:
        break
}
       cell.cellTextField.tag = indexPath.row
       return cell
    }
}

// MARK: - Extension PickerView
extension ShippingViewController: UIPickerViewDelegate, UIPickerViewDataSource {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}
func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//    switch pickerView.tag {
//      case 0:
//        return Address.count
//      case 4:
//        return countries.count
//      case 5:
//        return provinces.count
//      default:
//        return 0
//    }
    if pickerView == addressPicker{
        return Address.count
    }
    else if pickerView == countryPicker{
        print(countries.count)
        return countries.count
    }
    else if pickerView == statePicker{
        return provinces.count
    }
    else{
        return 0
    }
}
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//    switch pickerView.tag {
//      case 0:
//        return Address[row]
//      case 4:
//        return countries[row]
//      case 5:
//        return provinces[row]
//      default:
//        return nil
//    }
    if pickerView == addressPicker{
        return Address[row]
    }
    else if pickerView == countryPicker{
        return countries[row]
    }
    else if pickerView == statePicker{
        return provinces[row]
    }
    else{
        return nil
    }
}
func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedTag = pickerView.tag
    guard selectedTag < shippingPeopleArr.count
    else {
       return
}
    var selectedPerson = shippingPeopleArr[selectedTag]
//    switch pickerView.tag {
//    case 0:
//        selectedPerson.Address = Address[row]
//    case 4:
//        selectedPerson.country = countries[row]
//    case 5:
//        selectedPerson.province = provinces[row]
//    default:
//        break
//}
    if pickerView == addressPicker{
        selectedPerson.Address = Address[row]
        self.existingAddressTxt.text = selectedPerson.Address
    }
    else if pickerView == countryPicker{
        selectedPerson.country = countries[row]
        self.countryTxt.text = selectedPerson.country
    }
    else if pickerView == statePicker{
        selectedPerson.province = provinces[row]
        self.stateTxt.text = selectedPerson.province
    }
    shippingPeopleArr[selectedTag] = selectedPerson
    shippingTableView.reloadData()
   }
}


