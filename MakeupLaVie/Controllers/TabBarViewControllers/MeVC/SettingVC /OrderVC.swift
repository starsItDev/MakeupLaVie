//
//  OrderVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class OrderVC: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!
    var myOrder = [MyOrderResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myOrderAPI()
    }
    
    //MARK: - Helper Functions
    func myOrderAPI() {
        let urlString = base_url + "user/orders"
        Networking.instance.getApiCall(url: urlString) { (response, error, statusCode) in
            if error == nil && statusCode == 200 {
                do {
                    let jsonData = try response.rawData()
                    let decoder = JSONDecoder()
                    let myOrderModel = try decoder.decode(MyOrderModel.self, from: jsonData)
                    print("Status Code: \(myOrderModel.statusCode)")
                    self.myOrder = myOrderModel.body.response
                    DispatchQueue.main.async {
                        self.orderTableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else {
                print("Something went wrong")
            }
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

// MARK: - Extension UITableView
extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrder[section].products.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return myOrder.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let orderHeader = Bundle.main.loadNibNamed("OrderHeaderView", owner: OrderVC.self, options: nil)?.first as! OrderHeaderView
        let totalSections = myOrder.count
        let reversedOrderNumber = totalSections - section
        orderHeader.orderNamelbl.text = "Order # \(reversedOrderNumber)"
        orderHeader.initialLbl.text = myOrder[section].status
        return orderHeader
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let orderFooter = Bundle.main.loadNibNamed("OrderFooterView", owner: OrderVC.self, options: nil)?.first as! OrderFooterView
        orderFooter.subTotalLbl.text = "\(Double(myOrder[section].subTotal))"
        orderFooter.shippingPriceLbl.text = "\(Double(myOrder[section].shippingPrice))"
        orderFooter.taxLbl.text = "\(Double(myOrder[section].tax))"
        orderFooter.totalPriceLbl.text = "\(Double(myOrder[section].grandTotal))"
        orderFooter.itemCount.text = "\(myOrder[section].itemCount)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        if let date = dateFormatter.date(from: myOrder[section].createdAt) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: date)
            orderFooter.dateLbl.text = formattedDate
        } else {
            orderFooter.dateLbl.text = ""
        }
        return orderFooter
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderTableViewCell", for: indexPath) as! orderTableViewCell
        let products = myOrder[indexPath.section].products[indexPath.row]
        cell.orderTitle.text = products.title
        cell.orderPrice.text = Double(products.price)?.description
        cell.orderQuantity.text = "\(products.quantity)"
        let price = Double(products.price) ?? 0
        let quantity = Double(products.quantity)
        let totalPrice = price * quantity
        cell.totalPrice.text = "\(totalPrice)"
        cell.myOrderImage.sd_setImage(with: URL(string: products.image))
        return cell
    }
}
