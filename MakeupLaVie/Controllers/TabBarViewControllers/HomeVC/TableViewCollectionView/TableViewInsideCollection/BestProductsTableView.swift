//
//  BestProductsTableView.swift
//  MakeupLaVie
//
//  Created by StarsDev on 29/05/2023.
//

import UIKit
protocol BestProductsTableViewDelegate: AnyObject {
    func Wishlist(selectedID: Int?)
    func getCellIndex(_ cell: BestProductCollectionCell) -> Int?
}
class BestProductsTableView: UITableViewCell, BestProductsTableViewDelegate {
    private var viewModel = MianHomeViewModel()
    weak var delegate: CollectionViewCellDelegate?
    var responseIds: [Int] = []
    var selectedID: Int?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        configuration()
        self.collectionView.register(UINib(nibName: "BestProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BestProductCollectionCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func Wishlist(selectedID: Int?) {
            guard let selectedID = selectedID else {
                print("No selected ID available")
                return
            }
        let parameters = """
        {
            "id": "\(selectedID)"
        }
        """

        guard let postData = parameters.data(using: .utf8) else { return }
        guard let url = URL(string: "https://shop.plazauk.com/api/wishlist") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiNGNiMzg1MWJmYjU5NDcwYjkzNGRiNDA0YTRkM2NjNGQ3YTA5N2Y3ZjUzYzFhOGViODVmNzYwYjE2ZmM0ZTQwNDEyNzljOWZiYzYyNTU1NTQiLCJpYXQiOjE2ODgzNjI4NzUsIm5iZiI6MTY4ODM2Mjg3NSwiZXhwIjoxNjg4Nzk0ODc1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.rLRqiMlwHBlsvTyfJnOeF4Pf_UMH3cwpsr2F99bfvm8i_41XqudjQxO2JLlz7v-yPvPwC0IEMxeH7RPrsfNEK6bQtCLLmKSPiOQcEfYY5wVwZaOl8SuifUYYCsfyAMTzUssv7ZnB2MEWrrjUmD-b0GYNKv_DY2Q0TTMJXbY1W-seWU47w-96bvJV5yncSdXf4ta8zalzMwoEwZpJ1RUDRjnmnDq4P8LKYt5UEh8dtkGQkttARckEasL6u80uNwOKPk-gYHORv1p2dTn_YENP0Z54hGWvXqy1FtQ72n0Q4rbB5u8iWIa3XB2_Xsv1k_KYrFeMAbT-B-1XcaBHEs85sS9QENMzBjLjSD7ThCuZJBTdcXD7XiZeNNls6J5Y5vRlH2BsbWe0fhpppzqnpjhqUz-LdbgEKvpPTsmOlPiiYsDDM_ynk48PGAqAUL5bzX02sMPrqqR7hoPGpFmN_ON5NCjAOUl0nWlxH_krlxYj31T6C6qhYKQ0MMk-OJyy9CDm759_khhi0HnfaGX2Z4CzdtMjZ2aESNVsyGiJUWMcGO7hJRDFH8wLxR-uuOkLgZKunllmLqF4xa06tPzICUHuXMEY1Wr4XjIpExcQkM0BZnqa1xhXL3jNFPP_ZIAWSn_7vHCBCALx1MBY76_nEMS3GuTlYWjzLRWEZI4mCu-5C0Q", forHTTPHeaderField: "Authorization")
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(response as Any)
            guard let data = data else {
                print(String(describing: error))
                return
            }
            if let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
            }
        }

        task.resume()
    }
    
    func getCellIndex(_ cell: BestProductCollectionCell) -> Int? {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return nil
        }
        return indexPath.item
    }

    
}
extension BestProductsTableView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalItems = 0
            
            for product in viewModel.products {
                totalItems += product.body.bestProducts.count
            }
            
            return totalItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestProductCollectionCell", for: indexPath) as! BestProductCollectionCell
        
        cell.delegate = self
        
        var currentIndex = 0

            for product in viewModel.products {
                let responseCount = product.body.bestProducts.count

                if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
                    let itemIndex = indexPath.item - currentIndex
                    let specialOffer = product.body.bestProducts[itemIndex]
                    cell.titleLbl.text = product.body.bestProducts[itemIndex].title
                    cell.rsLbl.text = product.body.bestProducts[itemIndex].price
                    cell.imgView.setImage(with: product.body.bestProducts[itemIndex].image)
                    let wishList = product.body.bestProducts[itemIndex].hasWishlist
                    UserDefaults.standard.set(wishList, forKey: "hasWishlist")
                    let responseId = specialOffer.id
                    responseIds.append(responseId)
                    
                    cell.selectedID = responseId
                    cell.selectedID = specialOffer.id
                    cell.configureCell(with: wishList)
                    break
                }
                currentIndex += responseCount
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 450)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = responseIds[indexPath.row]
        self.selectedID = selectedID

            
            delegate?.didSelectItemAtIndex(index: indexPath.row, selectedID: selectedID)
        }
    }
extension BestProductsTableView {
    func configuration() {
        initViewModel()
        observeEvent()
    }
    func initViewModel() {
        viewModel.fetchProduct()
    }
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .loading:
                print("Product loading....")
            case .stopLoading:
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                print(self.viewModel.products)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .error(let error):
                print(error)
            }
        }
    }
}
