//
//  BrowseProductModel.swift
//  MakeupLaVie
//
//  Created by StarsDev on 13/06/2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct BrowseProductModel: Codable {
    let statusCode: Int
    let body: BrowseProductBody

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case body
    }
}

// MARK: - Body
struct BrowseProductBody: Codable {
    let totalItemCount, totalPages: Int
    let response: [BrowseProductResponse]
}

// MARK: - Response
struct BrowseProductResponse: Codable {
    let id: Int
    let title, description, keywords: String
    let photoID, ownerID, categoryID, status: Int
    let price, discount: String
    let stock, viewCount, sellCount, brandID: Int
    let createdAt, updatedAt: String
    let featured, sponsored, newlabel, hotlabel: Int
    let salelabel, speciallabel: Int
    let image, imageProfile, imageIcon: String
    let hasCompare, hasWishlist, hasCartItem: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, description, keywords
        case photoID = "photo_id"
        case ownerID = "owner_id"
        case categoryID = "category_id"
        case status, price, discount, stock
        case viewCount = "view_count"
        case sellCount = "sell_count"
        case brandID = "brand_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case featured, sponsored, newlabel, hotlabel, salelabel, speciallabel, image
        case imageProfile = "image_profile"
        case imageIcon = "image_icon"
        case hasCompare, hasWishlist, hasCartItem
    }
}

//import UIKit
//
//class SearchVC: UIViewController {
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var searchBar: UISearchBar!
//    
//    private var viewModel = BrowseProductViewModel()
//    private var responseIds: [Int] = []
//    private var filteredProducts: [BrowseProductModel] = []
//    private var isSearching: Bool {
//        return !searchBar.text?.isEmpty ?? false
//    }
//    private var refreshControl: UIRefreshControl!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configure()
//        setupTapGesture()
//        setupRefreshControl()
//        registerFooterView()
//    }
//    
//    private func configure() {
//        searchBar.delegate = self
//        initViewModel()
//        observeEvent()
//    }
//    
//    private func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        collectionView.addGestureRecognizer(tapGesture)
//    }
//    
//    private func setupRefreshControl() {
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        collectionView.refreshControl = refreshControl
//    }
//    
//    private func registerFooterView() {
//        collectionView.register(
//            UICollectionReusableView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
//            withReuseIdentifier: "FooterView"
//        )
//    }
//    
//    @objc private func refreshData() {
//        // Perform any necessary data fetching or updates here
//        
//        // End refreshing when done
//        refreshControl.endRefreshing()
//        
//        // Reload the collection view data if needed
//        collectionView.reloadData()
//    }
//    
//    @objc private func dismissKeyboard() {
//        searchBar.resignFirstResponder() // Dismiss the keyboard
//    }
//    
//    @IBAction func startBtn(_ sender: UIButton) {
//        let vc = UIStoryboard(name: "Main", bundle: Bundle.main)
//            .instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
//        self.navigationController?.pushViewController(vc!, animated: true)
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//
//extension SearchVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if isSearching {
//            return filteredProducts.reduce(0) {
//                $0 + $1.body.response.filter {
//                    $0.title.localizedCaseInsensitiveContains(searchBar.text ?? "")
//                }.count
//            }
//        } else {
//            var totalItems = 0
//            for product in viewModel.products {
//                totalItems += product.body.response.count
//            }
//            return totalItems
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchVCCollectionView
//        
//        if isSearching {
//            var filteredProductsCount = 0
//            let filteredItemIndex = indexPath.item
//            
//            // Find the corresponding item index in the filteredProducts array
//            for product in filteredProducts {
//                let responseCount = product.body.response.count
//                if filteredItemIndex < filteredProductsCount + responseCount {
//                    let itemIndex = filteredItemIndex - filteredProductsCount
//                    let specialOffer = product.body.response
//                        .filter { $0.title.localizedCaseInsensitiveContains(searchBar.text ?? "") }[itemIndex]
//                    configureCell(cell, with: specialOffer)
//                    let responseId = specialOffer.id
//                    responseIds.append(responseId)
//                    break
//                }
//                filteredProductsCount += responseCount
//            }
//        } else {
//            var totalRecentProducts = 0
//            for product in viewModel.products {
//                totalRecentProducts += product.body.response.count
//            }
//            
//            if indexPath.item < totalRecentProducts {
//                var currentIndex = 0
//                for product in viewModel.products {
//                    let responseCount = product.body.response.count
//                    if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
//                        let itemIndex = indexPath.item - currentIndex
//                        let specialOffer = product.body.response[itemIndex]
//                        configureCell(cell, with: specialOffer)
//                        let responseId = specialOffer.id
//                        responseIds.append(responseId)
//                        break
//                    }
//                    currentIndex += responseCount
//                }
//            }
//        }
//        return cell
//    }
//    
//    private func configureCell(_ cell: SearchVCCollectionView, with specialOffer: BrowseProductResponse) {
//        cell.titleLbl.text = specialOffer.title
//        cell.rsLbl.text = specialOffer.price
//        cell.imgView.setImage(with: specialOffer.image)
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//
//extension SearchVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedID = responseIds[indexPath.row]
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC else {
//            return
//        }
//        nextViewController.selectedResponseID = selectedID
//        self.present(nextViewController, animated: true, completion: nil)
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension SearchVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 165, height: 345)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        // Adjust the height and width based on your requirements
//        return CGSize(width: collectionView.bounds.width, height: 50)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionFooter {
//            let footerView = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: "FooterView",
//                for: indexPath
//            )
//            
//            // Create a new UIActivityIndicatorView
//            let activityIndicator = UIActivityIndicatorView(style: .medium)
//            activityIndicator.center = footerView.center
//            footerView.addSubview(activityIndicator)
//            
//            // Start animating the activity indicator
//            activityIndicator.startAnimating()
//            
//            // Adjust the frame of the activity indicator as needed
//            // activityIndicator.frame = ...
//            
//            return footerView
//        }
//        return UICollectionReusableView()
//    }
//}
//
//// MARK: - UISearchBarDelegate
//
//extension SearchVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filterProducts(with: searchText)
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        collectionView.reloadData()
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder() // Dismiss the keyboard
//        
//        // Perform search or any other actions
//        
//        // Reload the collection view data if needed
//        collectionView.reloadData()
//    }
//    
//    func filterProducts(with searchText: String) {
//        filteredProducts = viewModel.products.filter { product in
//            let filteredRecentProducts = product.body.response.filter {
//                $0.title.localizedCaseInsensitiveContains(searchText)
//            }
//            return !filteredRecentProducts.isEmpty
//        }
//        collectionView.reloadData()
//    }
//}
//
//// MARK: - ViewModel
//
//extension SearchVC {
//    func initViewModel() {
//        viewModel.fetchProduct()
//    }
//    
//    func observeEvent() {
//        viewModel.eventHandler = { [weak self] event in
//            guard let self = self else { return }
//            
//            switch event {
//            case .loading:
//                print("Product loading...")
//            case .stopLoading:
//                print("Stop loading...")
//            case .dataLoaded:
//                print("Data loaded...")
//                print(self.viewModel.products)
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            case .error(let error):
//                print(error)
//            }
//        }
//    }
//}
