//
//  ReviewViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 08/08/2023.
//

import UIKit

struct Product{
    var title: String
    var price: String
    var quantity: String
    var image: String
    var salePrice: String
}
struct BillingAddress {
    var name: String
    var address: String
    var phone: String
}
struct ShippingAddress {
    var name: String
    var address: String
    var phone: String
}

class ReviewViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var shippingNameLbl: UILabel!
    @IBOutlet weak var shippingAddressLbl: UILabel!
    @IBOutlet weak var shippingPhoneLbl: UILabel!
    @IBOutlet weak var billingNameLbl: UILabel!
    @IBOutlet weak var billingAddressLbl: UILabel!
    @IBOutlet weak var billingPhoneLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var orderNoteTxt: UITextField!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var reviewTableHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var images: [UIImage?] = [UIImage(named: "emptyCheck"), UIImage(named: "walkInCustomer")]
    var paymentId = 1
    var termsCondition = 1
    var prodArr = [Product]()
    var billingAddress: [BillingAddress] = []
    var shippingAddress: [ShippingAddress] = []
    
    //MARK: - Override function
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.estimatedRowHeight = 105
        orderNoteTxt.layer.borderWidth = 1
        orderNoteTxt.layer.borderColor = UIColor.black.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        self.callPreviewOrderAPI()
    }
    
    //MARK: - Helper Functions
    @IBAction func uncheckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setImage(UIImage(named: "tick"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "unCheck"), for: .normal)
        }
    }
    @IBAction func backToPayment(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkOutBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func termsConditionBtn(_ sender: UIButton) {
        if let url = URL(string: "https://shop.plazauk.com/help/terms") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func completeBtn(_ sender: UIButton) {
        if !termsBtn.isSelected {
            utilityFunctions.showAlertWithTitle(title: "Alert", withMessage: "Please agree to terms and conditions", withNavigation: self)
        } else {
            let params: [String: Any] = [
                "billing_address": billingId,
                "shipping_address": shippingId,
                "payment_method": paymentId,
                "terms": termsCondition,
                "order_note": orderNoteTxt.text ?? ""
            ]
            postCompleteOrderAPICall(params: params)
        }
    }
    func postCompleteOrderAPICall(params: [String: Any]) {
        let url = base_url + "checkout/order"
        Networking.instance.postApiCall(url: url, param: params) { (response, error, statusCode) in
            if error == nil {
                if statusCode == 200 {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderVC") as? OrderVC {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    print("Status code: \(statusCode)")
                }
            } else {
                print("API call error")
            }
        }
    }
    func callPreviewOrderAPI(){
        let queryItems = [URLQueryItem(name: "billing_address", value: "\(billingId )"), URLQueryItem(name: "shipping_address", value: "\(shippingId)"), URLQueryItem(name: "payment_method", value: "\(paymentId )")]
        var urlComp = URLComponents(string: base_url + "checkout/order")
        urlComp?.queryItems = queryItems
        Networking.instance.getApiCall(url: urlComp?.string ?? ""){(response, error, statusCode) in
            print(response)
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary{
                    if let addresses = body["addresses"]?.array {
                        for i in addresses{
                            let type = i["type"].stringValue
                            if type == "billing"{
                                let firstName = i["first_name"].stringValue
                                let lastName = i["last_name"].stringValue
                                let address = i["address_1"].stringValue
                                let number = i["phone"].stringValue
                                let addresses = BillingAddress(name: "\(firstName) \(lastName)", address: address, phone: number)
                                self.billingAddress.append(addresses)
                            } else if type == "shipping" {
                                let firstName = i["first_name"].stringValue
                                let lastName = i["last_name"].stringValue
                                let address = i["address_1"].stringValue
                                let number = i["phone"].stringValue
                                let addresses = ShippingAddress(name: "\(firstName) \(lastName)", address: address, phone: number)
                                self.shippingAddress.append(addresses)
                            }
                        }
                    }
                    if let products = body["products"]?.array{
                        for item in products {
                            let title = item["title"].stringValue
                            let price = item["price"].stringValue
                            let quantity = item["quantity"].stringValue
                            let image = item["image"].stringValue
                            let saleprice = item["sale_price"].stringValue
                            let obj = Product(title: title, price: price, quantity: quantity, image: image, salePrice: saleprice)
                            self.prodArr.append(obj)
                        }
                        self.reviewTableView.reloadData()
                        let contentHeight = self.reviewTableView.contentSize.height
                        self.reviewTableHeight.constant = contentHeight
                    }
                    
                    if let payment = body["payment_method"]{
                        self.paymentMethodLbl.text = payment["title"].stringValue
                    }
                    if let totalPrice = body["total"]?.stringValue{
                        if let totalPriceDouble = Double(totalPrice) {
                            self.totalPriceLbl.text = String(totalPriceDouble)
                        }
                    }
                }
                self.billingNameLbl.text = self.billingAddress.last?.name
                self.billingAddressLbl.text = self.billingAddress.last?.address
                self.billingPhoneLbl.text = self.billingAddress.last?.phone
                self.shippingNameLbl.text = self.shippingAddress.last?.name
                self.shippingAddressLbl.text = self.shippingAddress.last?.address
                self.shippingPhoneLbl.text = self.shippingAddress.last?.phone
            }
        }
    }
}
//MARK: - Extension TableView
extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prodArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewTableViewCell
        cell.reviewItemNameLbl.text = prodArr[indexPath.row].title
        var price = String()
        if prodArr[indexPath.row].salePrice == "-1.00"
        {
            price = prodArr[indexPath.row].price
        } else {
            price = prodArr[indexPath.row].salePrice
        }
        let quantity = prodArr[indexPath.row].quantity
        cell.reviewPriceNameLbl.text = "\(price) x \(quantity)"
        let imageUrl = prodArr[indexPath.row].image
        cell.reviewTableImage.sd_setImage(with: URL(string: imageUrl))
        return cell
    }
}
