//
//  MyReviewsVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit

class MyReviewsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var reviewModel = [MyReviewResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        myReviewAPI()
    }
    func myReviewAPI() {
        let urlString = base_url + "user/reviews"
        Networking.instance.getApiCall(url: urlString) { (response, error, statusCode) in
            if error == nil && statusCode == 200 {
                do {
                    let jsonData = try response.rawData()
                    let decoder = JSONDecoder()
                    let myOrderModel = try decoder.decode(MyReviewModel.self, from: jsonData)
                    print("Status Code: \(myOrderModel.statusCode)")
                    self.reviewModel.append(contentsOf: myOrderModel.body.response)
                    DispatchQueue.main.async {
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
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.estimatedRowHeight = 10.0
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil),forCellReuseIdentifier:"ReviewsTableViewCell")
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension MyReviewsVC: UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewModel.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell",for: indexPath) as? ReviewsTableViewCell? else {
            fatalError()
        }
        let reviews = reviewModel[indexPath.row]
        cell?.titleNameLabel.text = reviews.product.title
        cell?.desLabel.text = reviews.product.description.htmlToPlainText
        cell?.reviewsLabel.text = reviews.review
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        if let date = dateFormatter.date(from: reviews.product.createdAt) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: date)
            cell?.dateLabel.text = formattedDate
        } else {
            cell?.dateLabel.text = ""
        }
        cell?.imageReviewView.setImage(with: reviews.product.imageIcon)
        cell?.ratingView.rating = Double(reviews.rating)
        return cell ?? UITableViewCell()
    }
}

