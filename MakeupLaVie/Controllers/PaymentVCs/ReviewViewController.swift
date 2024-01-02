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
}


protocol ReviewViewControllerDelegate{
    func didTapBackToPayment()
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
    
    //MARK: Variables
    var delegate: ReviewViewControllerDelegate?
    var images: [UIImage?] = [UIImage(named: "emptyCheck"), UIImage(named: "walkInCustomer")]
//    var billingId: Int?
//    var shippingId: Int?
    var paymentId = 1
    var prodArr = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.callPreviewOrderAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.callPreviewOrderAPI()
    }
    @IBAction func uncheckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
           sender.setImage(UIImage(named: "black"), for: .normal)
    } else {
           sender.setImage(UIImage(named: "unCheck"), for: .normal)
       }
    }
    @IBAction func backToPayment(_ sender: UIButton) {
        delegate?.didTapBackToPayment()
    }
    
    func callPreviewOrderAPI(){
        let queryItems = [URLQueryItem(name: "billing_address", value: "\(billingId )"), URLQueryItem(name: "shipping_address", value: "\(shippingId)"), URLQueryItem(name: "payment_method", value: "\(paymentId )")]
        var urlComp = URLComponents(string: base_url + "checkout/order")
        urlComp?.queryItems = queryItems
        Networking.instance.getApiCall(url: urlComp?.string ?? ""){(response, error, statusCode) in
            print(response)
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary{
                    
                    if let billingAddr = body["billing_address"]{
                                let firstName = billingAddr["first_name"].stringValue
                                let lastName = billingAddr["last_name"].stringValue
                                self.billingNameLbl.text = "\(firstName) \(lastName)"
                                self.billingAddressLbl.text = billingAddr["address_1"].stringValue
                                self.billingPhoneLbl.text = billingAddr["phone"].stringValue
                    }
                    if let shippingAddr = body["shipping_address"]{
                        let firstName = shippingAddr["first_name"].stringValue
                        let lastName = shippingAddr["last_name"].stringValue
                        self.shippingNameLbl.text = "\(firstName) \(lastName)"
                        self.shippingAddressLbl.text = shippingAddr["address_1"].stringValue
                        self.shippingPhoneLbl.text = shippingAddr["phone"].stringValue
                    }
                    
                    if let products = body["products"]?.array{
                        for item in products {
                            let title = item["title"].stringValue
                            let price = item["price"].stringValue
                            let quantity = item["quantity"].stringValue
                            let image = item["image"].stringValue
                            let obj = Product(title: title, price: price, quantity: quantity, image: image)
                            self.prodArr.append(obj)
                        }
                        self.reviewTableView.reloadData()
                    }
                    
                    if let payment = body["payment_method"]{
                        self.paymentMethodLbl.text = payment["title"].stringValue
                    }
                    if let totalPrice = body["total"]?.stringValue{
                        self.totalPriceLbl.text = totalPrice
                    }
                }
            }
        }
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewTableViewCell
        cell.reviewItemNameLbl.text = prodArr[indexPath.row].title
        let price = prodArr[indexPath.row].price
        let quantity = prodArr[indexPath.row].quantity
        cell.reviewPriceNameLbl.text = "\(price) x \(quantity)"
        let imageUrl = prodArr[indexPath.row].image
        cell.reviewTableImage.sd_setImage(with: URL(string: imageUrl))
        return cell
    }
    
    
}
