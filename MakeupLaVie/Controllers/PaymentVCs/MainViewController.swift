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
    
    @IBOutlet weak var shippingLineView: UIView!
    @IBOutlet weak var paymentLineView: UIView!
    @IBOutlet weak var reviewLineView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "billingsegue"{
//            //if let checkoutVC = segue.destination as? CheckoutViewController {
//            let checkoutVC = segue.destination as? CheckoutViewController
//            checkoutVC?.delegate = self
//            checkoutVC?.checkOutDetailsAPI()
//            //}
//
//        }
//        else if let shippingVC = segue.destination as? ShippingViewController {
//               shippingVC.delegate = self
//            shippingVC.checkOutDetailsAPI()
//        }
//        else if let paymentVC = segue.destination as? PaymentViewController {
//            paymentVC.delegate = self
//        }
//        else if let reviewVC = segue.destination as? ReviewViewController{
//            reviewVC.delegate = self
//            reviewVC.callPreviewOrderAPI()
//        }
//    }
//    func scrollHalf() {
//        let xOffset = scrollView.contentSize.width * 0.4
//                scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
//        }
//    func scrollToInitialPosition() {
//           scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//   }
//
//    @IBAction func backBtnTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//}
//
//extension MainViewController: CheckoutViewControllerDelegate {
//    func didSelectShippingButton(changeLineColor: Bool) {
//        if changeLineColor {
//            shippingLineView.backgroundColor = UIColor.red
//        }
//
//    }
//}
//extension MainViewController: ShippingViewControllerDelegate {
//
//    func didTapBackToCheckout() {
//        shippingLineView.backgroundColor = UIColor.gray
//
//}
//    func didSelectPaymentButton(changeLineColor: Bool) {
//        if changeLineColor{
//            paymentLineView.backgroundColor = UIColor.red
//        }
//    }
//}
//extension MainViewController: paymentViewControllerDelegate{
//
//    func didTapBackToShipping() {
//        paymentLineView.backgroundColor = UIColor.gray
//}
//    func didSelectReviewButton(changeLineColor: Bool) {
//        if changeLineColor{
//            reviewLineView.backgroundColor = UIColor.red
//        }
//    }
//
//}
//
//extension MainViewController: ReviewViewControllerDelegate{
//
//    func didTapBackToPayment() {
//        reviewContainerView.isHidden = true
//        reviewLineView.backgroundColor = UIColor.gray
//    }
//}






