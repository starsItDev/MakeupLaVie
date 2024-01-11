//
//  OrderVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class OrderVC: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backBtn(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        
//        let leftBorderLayer = CALayer()
//        leftBorderLayer.frame = CGRect(x: 0, y: 0, width: 1.0, height: tableView.frame.size.height)
//        leftBorderLayer.backgroundColor = UIColor.lightGray.cgColor
//        orderHeader.layer.addSublayer(leftBorderLayer)
//
//        let rightBorderLayer = CALayer()
//        rightBorderLayer.frame = CGRect(x: tableView.frame.size.width - 1.0, y: 0, width: 1.0, height: orderHeader.frame.size.height)
//        rightBorderLayer.backgroundColor = UIColor.lightGray.cgColor
//        orderHeader.layer.addSublayer(rightBorderLayer)
//        
//        let topBorderLayer = CALayer()
//        topBorderLayer.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1.0)
//        topBorderLayer.backgroundColor = UIColor.lightGray.cgColor
//        orderHeader.layer.addSublayer(topBorderLayer)
        return orderHeader
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let orderFooter = Bundle.main.loadNibNamed("OrderFooterView", owner: OrderVC.self, options: nil)?.first as! OrderFooterView
       
//        let bottomBorderLayer = CALayer()
//        bottomBorderLayer.frame = CGRect(x: 0, y: tableView.frame.size.height - 1.0, width: tableView.frame.size.width, height: 1.0)
//        bottomBorderLayer.backgroundColor = UIColor.lightGray.cgColor
//        orderFooter.layer.addSublayer(bottomBorderLayer)
        return orderFooter
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderTableViewCell", for: indexPath) as! orderTableViewCell
//        let leftBorderLayer = CALayer()
//        leftBorderLayer.frame = CGRect(x: 0, y: 0, width: 1.0, height: cell.frame.size.height)
//        leftBorderLayer.backgroundColor = UIColor.lightGray.cgColor
//        cell.layer.addSublayer(leftBorderLayer)
//        let rightBorderLayer = CALayer()
//        rightBorderLayer.frame = CGRect(x: cell.frame.size.width - 1.0, y: 0, width: 1.0, height: cell.frame.size.height)
//        rightBorderLayer.backgroundColor = UIColor.lightGray.cgColor
//        cell.layer.addSublayer(rightBorderLayer)
        return cell
    }
    
    
}
