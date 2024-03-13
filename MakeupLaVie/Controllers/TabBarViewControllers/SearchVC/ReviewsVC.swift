//
//  ReviewsVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 19/04/2023.
//

import UIKit

class ReviewsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var productName: UILabel!
    
    
    @IBOutlet weak var reviews1Label: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:false, completion:nil)
    }
}
extension ReviewsVC: UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell",for: indexPath) as? ReviewsTableViewCell? else {
            fatalError()
        }
        cell?.dateLabel.isHidden = true
        cell?.reviewsLabel.text = "testing"
        cell?.desLabel.text = "3 Mar,2024"
        return cell ?? UITableViewCell()
    }
}

