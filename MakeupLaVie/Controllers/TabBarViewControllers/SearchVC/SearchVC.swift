import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var noProductView: UIView!
    
    private var viewModel = BrowseProductViewModel()
    
    var isFilter = false
    var params = [String: Any]()
    var responseIds: [Int] = []
    var selectedIDResponse: Int?
    var filteredProducts: [GenericListingModel] = []
    var products: [GenericListingModel] = []
    var isSearching: Bool {
        return searchBar.text?.isEmpty == false
    }
    private var currentPage = 1
    private var isLoadingData = false
    private var isBottomLoading = false
    var totalPages = -1
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tapGesture)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
        fetchDataFromAPI(page: currentPage)
        configurePagination()
        NotificationCenter.default.addObserver(self, selector: #selector(filterData), name: NSNotification.Name(rawValue: "Data"), object: nil)
        
        searchBar.layer.cornerRadius = 6
        searchBar.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.masksToBounds = true
        
        filterBtn.layer.cornerRadius = 6
        filterBtn.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configurePagination() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func filterData(_ notification: Notification){
        let data = notification.userInfo?["userInfo"] as! [String:Any]
        print(data)
        self.params = data
        self.isFilter = true
        fetchDataFromAPI(page: currentPage)
    }
    @objc func refreshData() {
        currentPage = 1
        self.products.removeAll()
        searchBar.text = ""
        fetchDataFromAPI(page: currentPage)
        refreshControl.endRefreshing()
    }
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func configure() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        //       searchBar.searchTextField.backgroundColor = UIColor.white
        //initViewModel()
        //observeEvent()
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.prefetchDataSource = self
    }
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        performSearch()
    }

    func performSearch() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            // If the search text is empty, reset to display all products
            filteredProducts = products
            collectionView.reloadData()
            return
        }

        // Filter products based on search text
        filteredProducts = products.filter { product in
            product.catagorylabel.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
        
        // Check if there are no matching products
        if filteredProducts.isEmpty {
            // Show the noProductView if no products match the search query
            noProductView.isHidden = false
        } else {
            // Hide the noProductView if there are matching products
            noProductView.isHidden = true
        }
    }

    @IBAction func filterBtnTapped(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandPKViewController") as! BrandPKViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func heartBtnTapped(sender: UIButton){
        let id = products[sender.tag].id ?? 0
        WishList.wishListAPICall(id: id){(complete) in
            if complete == true{
                if self.products[sender.tag].hasWishlist!{
                    if self.traitCollection.userInterfaceStyle == .dark {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    self.products[sender.tag].hasWishlist = false
                }
                else{
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                    print("added in recent")
                    self.products[sender.tag].hasWishlist = true
                }
            }
            else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchcell", for: indexPath) as! collectioncell
        
        let instance = filteredProducts[indexPath.item]
        cell.productImg.setImage(with: instance.catagoryimage)
        
        
        cell.titleLbl.text = instance.catagorylabel
        let salePrice = (instance.sale_price as NSString).integerValue
        let price = (instance.price as NSString).integerValue
        if salePrice == price{
            cell.oldPriceLbl.isHidden = true
            cell.newPriceLbl.text = instance.sale_price
        }
        else{
            cell.oldPriceLbl.isHidden = false
            cell.newPriceLbl.text = instance.sale_price
            let attributedString = NSAttributedString(string: instance.price, attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            cell.oldPriceLbl.attributedText = attributedString
        }
        
        if instance.featured == 1{
            cell.featureLbl.text = "Featured"
        }
        else if instance.sponsored == 1{
            cell.featureLbl.text = "Sponsored"
        }
        else if instance.newLabel == 1{
            cell.featureLbl.text = "New"
        }
        else if instance.hotLabel == 1{
            cell.featureLbl.text = "Hot"
        }
        else if instance.saleLabel == 1{
            cell.featureLbl.text = "Sale"
        }
        else if instance.specialLabel == 1{
            cell.featureLbl.text = "Special"
        }
        
        
        if instance.hasWishlist == true{
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.heartBtn.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        }
        else {
            if traitCollection.userInterfaceStyle == .dark {
                cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.heartBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.heartBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        cell.heartBtn.tag = indexPath.item
        cell.heartBtn.addTarget(self, action: #selector(heartBtnTapped(sender:)), for: .touchUpInside)
        cell.cosmosRating.settings.fillMode = .precise
        cell.cosmosRating.rating = instance.rating ?? 0
        cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        cell.featureLbl.clipsToBounds = true
        cell.featureLbl.layer.cornerRadius = 8
        cell.featureLbl.layer.maskedCorners = [.layerMaxXMaxYCorner]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        destinationVC.selectedResponseID = products[indexPath.item].id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 250)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                // If the search text is empty, show all products
                filteredProducts = products
                collectionView.reloadData()
            }
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        // Clear the search and reload all products
        filteredProducts = products
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
        // Perform search when the search button is tapped
        performSearch()
    }
    
    // Your existing performSearch method remains the same
}

extension SearchVC {
  
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            // User has reached the bottom, load the next page
            loadMoreData()
        }
    }
    
    private func loadMoreData(){
        //get ready the data . fetch
        
        let nextPageNumber = currentPage + 1
        currentPage = nextPageNumber
        if currentPage <= totalPages{
            fetchDataFromAPI(page: currentPage)
        }
    }
    
    func fetchDataFromAPI(page: Int) {
        
        isLoadingData = true
        let url = base_url + "products?page=\(page)"
        if isFilter{
            
            Networking.instance.getApiCallWithParams(url: url, param: self.params){(response, error, statusCode) in
                if error == nil && statusCode == 200{
                    self.products.removeAll()
                    if let body = response["body"].dictionary{
                        print(response)
                        if body["totalPages"] != nil{
                            self.totalPages = body["totalPages"]?.intValue ?? 0
                        }
                        
                        if let res = body["response"]?.array{
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.products.append(model)
                                
                                
                            }
                            self.collectionView.reloadData()
                        }
                        
                    }
                    self.filteredProducts = self.products
                }
            }
        }
        else{
            Networking.instance.getApiCall(url: url){(response, error, statusCode) in
                if error == nil && statusCode == 200{
                    if let body = response["body"].dictionary{
                        print(response)
                        if body["totalPages"] != nil{
                            self.totalPages = body["totalPages"]?.intValue ?? 0
                        }
                        if let res = body["response"]?.array{
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.products.append(model)
                                
                            }
                            self.collectionView.reloadData()
                        }
                        
                    }
                    self.filteredProducts = self.products
                }
            }
        }
    }
}
