//
//  ReviewsVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 19/04/2023.
//

import UIKit
import Cosmos
protocol SecondViewControllerDelegate: AnyObject {
    func secondViewControllerDismissed()
}

class ReviewsVC: UIViewController, SecondViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var overallRatingLbl: UILabel!
    @IBOutlet weak var plusReviewbtn: UIButton!
    @IBOutlet weak var overallRating: CosmosView!
    @IBOutlet weak var fiveStarCount: UILabel!
    @IBOutlet weak var fourStarCount: UILabel!
    @IBOutlet weak var threeStarCount: UILabel!
    @IBOutlet weak var twoStarCount: UILabel!
    @IBOutlet weak var oneStarCount: UILabel!
    @IBOutlet weak var totalReviewCount: UILabel!
    @IBOutlet weak var fiveStarProgress: UIProgressView!
    @IBOutlet weak var fourStarProgress: UIProgressView!
    @IBOutlet weak var threeStarProgress: UIProgressView!
    @IBOutlet weak var twoStarProgress: UIProgressView!
    @IBOutlet weak var oneStarProgress: UIProgressView!
    var giftName: String?
    var productId: Int?
    var canReview: Bool?
    var comingFromAdd = false
    var productReview = [ReviewResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        productName.text = giftName
        if canReview == false {
            plusReviewbtn.isHidden = true
        } else {
            plusReviewbtn.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        reviewAPI()
    }
    
    func secondViewControllerDismissed() {
        plusReviewbtn.isHidden = true
    }
    func reviewAPI() {
        let urlString = base_url + "product/reviews/\(productId ?? 0)"
        Networking.instance.getApiCall(url: urlString) { (response, error, statusCode) in
            if error == nil && statusCode == 200 {
                do {
                    let jsonData = try response.rawData()
                    let decoder = JSONDecoder()
                    let reviewModel = try decoder.decode(ReviewModel.self, from: jsonData)
                    print("Status Code: \(reviewModel.statusCode)")
                    self.productReview.append(contentsOf: reviewModel.body.response)
                    DispatchQueue.main.async {
                        if let body = response["body"].dictionary {
                            if let reviewStats = body["reviewStats"]?.dictionary {
                                let five = reviewStats["five_star_count"]?.intValue
                                let fiveProgress = reviewStats["five_star_percentage"]?.floatValue
                                let four = reviewStats["four_star_count"]?.intValue
                                let fourProgress = reviewStats["four_star_percentage"]?.floatValue
                                let three = reviewStats["three_star_count"]?.intValue
                                let threeProgress = reviewStats["three_star_percentage"]?.floatValue
                                let two = reviewStats["two_star_count"]?.intValue
                                let twoProgress = reviewStats["two_star_percentage"]?.floatValue
                                let one = reviewStats["one_star_count"]?.intValue
                                let oneProgress = reviewStats["one_star_percentage"]?.floatValue
                                let overallRating = reviewStats["overall_rating"]
                                self.fiveStarCount.text = "\(five ?? 0)"
                                self.fiveStarProgress.progress = (fiveProgress ?? 0) / 100
                                self.fiveStarProgress.progressTintColor = .red
                                self.fourStarCount.text = "\(four ?? 0)"
                                self.fourStarProgress.progress = (fourProgress ?? 0) / 100
                                self.fourStarProgress.progressTintColor = .red
                                self.threeStarCount.text = "\(three ?? 0)"
                                self.threeStarProgress.progress = (threeProgress ?? 0) / 100
                                self.threeStarProgress.progressTintColor = .red
                                self.twoStarCount.text = "\(two ?? 0)"
                                self.twoStarProgress.progress = (twoProgress ?? 0) / 100
                                self.twoStarProgress.progressTintColor = .red
                                self.oneStarCount.text = "\(one ?? 0)"
                                self.oneStarProgress.progress = (oneProgress ?? 0) / 100
                                self.oneStarProgress.progressTintColor = .red
                                self.overallRatingLbl.text = "\(overallRating ?? 0) Overall rating"
                                if let stringValue = reviewStats["overall_rating"]?.stringValue, let doubleValue = Double(stringValue) {
                                    self.overallRating.settings.fillMode = .precise
                                    self.overallRating.rating = doubleValue
                                } else {
                                    print("error")
                                }
                            }
                            let totalReview = body["totalItemCount"]
                            self.totalReviewCount.text = "\(totalReview ?? 0) Reviews"
                        }
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else {
                print("Something went wrong")
            }
        }
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 10.0
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil),forCellReuseIdentifier:"ReviewsTableViewCell")
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func plusbutton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
        nextViewController.delegate = self
        nextViewController.reviewProductId = self.productId
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
}
extension ReviewsVC: UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productReview.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell",for: indexPath) as? ReviewsTableViewCell? else {
            fatalError()
        }
        let review = productReview[indexPath.row]
        cell?.dateLabel.isHidden = true
        cell?.titleNameLabel.text = review.owner.title
        cell?.reviewsLabel.text = review.review
        cell?.desLabel.text = review.createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        if let date = dateFormatter.date(from: review.createdAt) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: date)
            cell?.desLabel.text = formattedDate
        } else {
            cell?.desLabel.text = ""
        }
        cell?.imageReviewView.setImage(with: review.owner.imageIcon)
        cell?.ratingView.settings.fillMode = .precise
        cell?.ratingView.rating = Double(review.rating)
        return cell ?? UITableViewCell()
    }
}

