//
//  CartVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 17/04/2023.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func deleteButtonPressed(at indexPath: IndexPath)
    func additems(at indexPath: IndexPath, quantity: Int)
    func minitems(at indexPath: IndexPath)
}

class CartVC: UIViewController {
    
    @IBOutlet weak var VoucherView: UIView!
    @IBOutlet weak var applyView: UIView!
    @IBOutlet weak var proccdingView: UIView!
    @IBOutlet var cardtableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var subtotalPrice: UILabel!
    
    var isQuantityLbl = false
    var quantity = Int()
    var total1 = String()
    var cartProductsArr: [CartModelResponse] = []
    var params = [String: Any]()
    let refreshControl = UIRefreshControl()
    var selectedResponseID: Int?
    private var responseID: Int?
    var totalPriceForPayment: String?
    var selectedAddOnIndexPaths: Set<IndexPath> = []
    var isDeleteButtonEnabled = true
    override func viewDidLoad() {
        super.viewDidLoad()
        VoucherView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.5882352941, blue: 0.2862745098, alpha: 1)
        VoucherView.layer.borderWidth = 1.0
        VoucherView.layer.cornerRadius = 8
        applyView.layer.cornerRadius = 8
        proccdingView.layer.cornerRadius = 8
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[3]
            tabItem.badgeValue = nil
        }
        fetchData()
        cardtableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.cardtableView.reloadData()
        
    }
    @objc private func refreshData() {
        fetchData()
        refreshControl.endRefreshing()
    }
    func fetchData() {
        self.cartProductsArr.removeAll()
        let url = base_url + "cart"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            print(response)
            if error == nil{
                if let body = response["body"].dictionary {
                    if let total = Double(body["total"]?.string ?? ""){
                        self.totalPrice.text = "\(total)"
                        self.totalPriceForPayment = "\(total)"
                    }
                    if let subTotal = Double(body["sub_total"]?.string ?? ""){
                        self.subtotalPrice.text = "\(subTotal)"
                    }
                    if body["totalItemCount"] != nil{
                    }
                    if let res = body["response"]?.array{
                        for dic in res{
                            let model = CartModelResponse.init(dic.rawValue as! Dictionary<String, AnyObject>)
                            self.cartProductsArr.append(model)
                            self.cardtableView.reloadData()
                            
                        }
                    }
                }
            }
            else{
                print("Someting went wrong")
            }
        }
        
    }
    @IBAction func checkoutBtnTapped(_ sender: Any) {
        if cartProductsArr.isEmpty {
            showToast(message: "No item in cart")
        } else {
            if UserInfo.shared.isUserLoggedIn{
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShippingViewController") as? ShippingViewController {
                    //checkOutVC.isComingFromEdit = false
                    self.tabBarController?.tabBar.isHidden = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else {
                let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        }
    }
    @objc func plusBtnTapped(sender: UIButton){
        
        let totalinInt = (Double(totalPrice.text ?? "") ?? 0) + (Double(cartProductsArr[sender.tag].sale_price) ?? 0)
        
        var qty = (cartProductsArr[sender.tag].quantity ?? 0)
        qty = qty + 1
        cartProductsArr[sender.tag].quantity = qty
        let indexpath = findIndexPath(for: sender.tag)
        let cell = cardtableView.cellForRow(at: indexpath ?? []) as! cartTableViewCell
        cell.quantityLb.text = "\(qty)"
        subtotalPrice.text = "\(totalinInt)"
        totalPrice.text = "\(totalinInt)"
    }
    @objc func minusBtnTapped(sender: UIButton) {
        let currentTotal = Double(totalPrice.text ?? "") ?? 0
        let productPrice = Double(cartProductsArr[sender.tag].sale_price) ?? 0
        var qty = (cartProductsArr[sender.tag].quantity ?? 0)
        if qty > 1 {
            qty = max(1, qty - 1)
            let newTotal = max(0, currentTotal - productPrice)
            totalPrice.text = "\(newTotal)"
            subtotalPrice.text = "\(newTotal)"
            let indexpath = findIndexPath(for: sender.tag)
            let cell = cardtableView.cellForRow(at: indexpath ?? []) as! cartTableViewCell
            cell.quantityLb.text = "\(qty)"
            cartProductsArr[sender.tag].quantity = qty
        }
    }
//    @objc func deleteBtnTapped(sender: UIButton){
//        let url = base_url + "cart/update"
//        params["id"] = cartProductsArr[sender.tag].id
//        params["quantity"] = cartProductsArr[sender.tag].quantity
//        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
//            if error == nil && statusCode == 200{
//                if let body = response["body"].dictionary{
//                    let message = body["message"]?.string ?? ""
//                    self.cartProductsArr.remove(at: sender.tag)
//                    self.cardtableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
//                    self.cardtableView.reloadData()
//                }
//            }
//        }
//    }
   

    @objc func deleteBtnTapped(sender: UIButton) {
        // Disable the delete button to prevent multiple clicks
        if !isDeleteButtonEnabled {
            return
        }

        isDeleteButtonEnabled = false

        let url = base_url + "cart/update"
        params["id"] = cartProductsArr[sender.tag].id
        params["quantity"] = cartProductsArr[sender.tag].quantity
        Networking.instance.postApiCall(url: url, param: params) { (response, error, statusCode) in
            // Enable the delete button after the API call is completed
            defer {
                self.isDeleteButtonEnabled = true
            }

            if error == nil && statusCode == 200 {
                if let body = response["body"].dictionary {
                    let message = body["message"]?.string ?? ""
                    self.cartProductsArr.remove(at: sender.tag)
                    self.cardtableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
                    self.cardtableView.reloadData()
                }
            }
        }
    }

}
extension CartVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cardtableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!  cartTableViewCell
        let product = cartProductsArr[indexPath.row]
        cell.productImg.setImage(with: product.image)
        cell.titleLbl.text = product.title
        cell.rsLbl.text = product.sale_price
        cell.quantityLb.text = "\(product.quantity ?? 1)"
        cell.dislbl.text = product.discount
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
        cell.plusBtn.tag = indexPath.row
        cell.plusBtn.addTarget(self, action: #selector(plusBtnTapped(sender:)), for: .touchUpInside)
        cell.minusBtn.tag = indexPath.row
        cell.minusBtn.addTarget(self, action: #selector(minusBtnTapped(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC {
            vc.selectedResponseID = cartProductsArr[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CartVC{
    func findIndexPath(for tag: Int) -> IndexPath? {
        for section in 0..<cardtableView.numberOfSections {
            for row in 0..<cardtableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = cardtableView.cellForRow(at: indexPath) as? cartTableViewCell, cell.minusBtn.tag == tag {
                    return indexPath
                }
            }
        }
        return nil
    }
}
