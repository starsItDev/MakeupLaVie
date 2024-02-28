//
//  PaymentViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 08/08/2023.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var cashOnDelivery: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewBtn: UIButton!
    
    //var onDismiss: (() -> Void)?

    var totalAmount = String()
    //var isReviewButtonEnabled = true
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "\(Double(totalAmount) ?? 0)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reviewBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func backToShipping(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkOutBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func reviewButton(_ sender: UIButton) {
//        if !isReviewButtonEnabled {
//                    return
//                }
//
//                isReviewButtonEnabled = false
        reviewBtn.isUserInteractionEnabled = false
        if cashOnDelivery.isSelected {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController {
//                vc.onDismiss = { [weak self] in
//                                    // Enable the review button after the ReviewViewController is dismissed
//                                    //self?.isReviewButtonEnabled = true
//                                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            showAlert()
            reviewBtn.isUserInteractionEnabled = true
            //isReviewButtonEnabled = true
        }
    }
    @IBAction func cashOnDeliveryButton(_ sender: UIButton) {
        cashOnDelivery.backgroundColor = UIColor.red
        cashOnDelivery.tintColor = UIColor.white
        cashOnDelivery.isSelected = true
    }
    private func showAlert() {
        let ac = UIAlertController(title: "Alert", message: "Please select a payment method", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        ac.addAction(action)
        present(ac, animated: true)
    }
}
