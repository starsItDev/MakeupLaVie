//
//  PaymentViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 08/08/2023.
//

import UIKit

protocol paymentViewControllerDelegate: AnyObject {
    func didTapBackToShipping()
    func didSelectReviewButton(changeLineColor: Bool)
}
class PaymentViewController: UIViewController {

    weak var delegate: paymentViewControllerDelegate?
    
    @IBOutlet weak var cashOnDelivery: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backToShipping(_ sender: UIButton) {
        delegate?.didTapBackToShipping()
    }
    @IBAction func reviewButton(_ sender: UIButton) {
        if cashOnDelivery.isSelected {
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
//            vc.callPreviewOrderAPI()
            delegate?.didSelectReviewButton(changeLineColor: true)
     } else {
         showAlert()
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
