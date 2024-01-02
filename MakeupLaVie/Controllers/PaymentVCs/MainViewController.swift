//
//  MainViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 07/08/2023.
//

import UIKit


var billingId = Int()
var shippingId = Int()
var paymentId = Int()

class MainViewController: UIViewController {
    
    @IBOutlet weak var billingContainerView: UIView!
    @IBOutlet weak var shippingContainerView: UIView!
    @IBOutlet weak var shippingLineView: UIView!
    @IBOutlet weak var paymentContainerView: UIView!
    @IBOutlet weak var paymentLineView: UIView!
    @IBOutlet weak var reviewContainerView: UIView!
    @IBOutlet weak var reviewLineView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billingContainerView.isHidden = false
        shippingContainerView.isHidden = true
        paymentContainerView.isHidden = true
        reviewContainerView.isHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "billingsegue"{
            //if let checkoutVC = segue.destination as? CheckoutViewController {
            let checkoutVC = segue.destination as? CheckoutViewController
            checkoutVC?.delegate = self
            checkoutVC?.checkOutDetailsAPI()
            //}
            
        }
        else if let shippingVC = segue.destination as? ShippingViewController {
               shippingVC.delegate = self
            shippingVC.checkOutDetailsAPI()
        }
        else if let paymentVC = segue.destination as? PaymentViewController {
            paymentVC.delegate = self
        }
        else if let reviewVC = segue.destination as? ReviewViewController{
            reviewVC.delegate = self
            reviewVC.callPreviewOrderAPI()
        }
    }
    func scrollHalf() {
        let xOffset = scrollView.contentSize.width * 0.4
                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        }
    func scrollToInitialPosition() {
           scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
   }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MainViewController: CheckoutViewControllerDelegate {
    func didSelectShippingButton(changeLineColor: Bool) {
        billingContainerView.isHidden = true
        shippingContainerView.isHidden = false
        if changeLineColor {
            shippingLineView.backgroundColor = UIColor.red
        }
        
    }
}
extension MainViewController: ShippingViewControllerDelegate {
    
    func didTapBackToCheckout() {
        billingContainerView.isHidden = false
        shippingContainerView.isHidden = true
        paymentContainerView.isHidden = true
        shippingLineView.backgroundColor = UIColor.gray
        
}
    func didSelectPaymentButton(changeLineColor: Bool) {
        billingContainerView.isHidden = true
        shippingContainerView.isHidden = true
        paymentContainerView.isHidden = false
        if changeLineColor{
            paymentLineView.backgroundColor = UIColor.red
        }
    }
}
extension MainViewController: paymentViewControllerDelegate{
    
    func didTapBackToShipping() {
        paymentContainerView.isHidden = true
        billingContainerView.isHidden = true
        shippingContainerView.isHidden = false
        paymentLineView.backgroundColor = UIColor.gray
}
    func didSelectReviewButton(changeLineColor: Bool) {
        billingContainerView.isHidden = true
        shippingContainerView.isHidden = true
        paymentContainerView.isHidden = true
        reviewContainerView.isHidden = false
        if changeLineColor{
            reviewLineView.backgroundColor = UIColor.red
        }
    }
    
}

extension MainViewController: ReviewViewControllerDelegate{
    
    func didTapBackToPayment() {
        billingContainerView.isHidden = true
        shippingContainerView.isHidden = true
        paymentContainerView.isHidden = false
        reviewContainerView.isHidden = true
        reviewLineView.backgroundColor = UIColor.gray
    }
}






