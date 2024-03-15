//
//  AddReviewVC.swift
//  MakeupLaVie
//
//  Created by Rao Ahmad on 12/03/2024.
//

import UIKit
import Cosmos

class AddReviewVC: UIViewController {

    @IBOutlet weak var cosmosRating: CosmosView!
    @IBOutlet weak var reviewTxtView: UITextView!
    var reviewProductId: Int?
    weak var delegate: SecondViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosRating.rating = 5
        reviewTxtView.text = "Write review"
        reviewTxtView.textColor = UIColor.lightGray
        reviewTxtView.delegate = self
    }
    
    @IBAction func backButtonButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }

    @IBAction func submitButton(_ sender: UIButton) {
        guard let reviewText = reviewTxtView.text,
              !reviewText.isEmpty,
              reviewText.trimmingCharacters(in: .whitespacesAndNewlines) != "Write review" else {
            utilityFunctions.showAlertWithTitle(title: "Alert", withMessage: "Please write a review before submitting", withNavigation: self)
            return
        }
        let params: [String: Any] = [
            "rating": "\(cosmosRating.rating)",
            "review": reviewTxtView.text ?? "",
            "recommend": "1"
        ]
        postCompleteOrderAPICall(params: params)
    }
    func postCompleteOrderAPICall(params: [String: Any]) {
        let url = base_url + "product/reviews/\(reviewProductId ?? 0)/create"
        Networking.instance.postApiCall(url: url, param: params) { (response, error, statusCode) in
            if error == nil {
                if statusCode == 200 {
                    self.dismiss(animated: true) {
                        self.delegate?.secondViewControllerDismissed()
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
}

extension AddReviewVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write review"
            textView.textColor = UIColor.lightGray
        }
    }
}
