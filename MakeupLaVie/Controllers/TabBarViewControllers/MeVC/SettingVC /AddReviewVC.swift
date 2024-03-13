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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

   @IBAction func submitButton(_ sender: UIButton) {
      let params: [String: Any] = [
        "rating": "\(cosmosRating.rating)",
         "review": reviewTxtView.text ?? "",
         "recommend": "1"
     ]
     postCompleteOrderAPICall(params: params)
 }
    func postCompleteOrderAPICall(params: [String: Any]) {
        let url = base_url + "product/reviews/11/create"
        Networking.instance.postApiCall(url: url, param: params) { (response, error, statusCode) in
            if error == nil {
                if statusCode == 200 {
                    if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyReviewsVC") as? MyReviewsVC {
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
}
