import UIKit

class CategoriesNextVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var toggleViewBtn: UIButton!
    @IBOutlet weak var categoriesSimpleCV: UICollectionView!
    @IBOutlet weak var categoriesGridCV: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var insdeCollectionView: UIView!
    
    // MARK: Variables & Properties
    var selectedID: Int?
    var selectedName: String?
    var productsArr: [GenericListingModel] = []
    var categoriesModel: CategoriesModel?
    var selectedIndex: Int?
    var prodAttribute: String?
    var seeAll: Bool?
    var isBrand: Bool?
    var totalPages = -1
    private var currentPage = 1
    var categoryID: Int?
    var params = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.titleLabel.text = selectedName
        if isBrand ?? false{
            //            urlString = base_url + "products?brand_id=\(selectedID)"
            self.params["brand_id"] = selectedID
        }
        else{
            self.params["category_id"] = selectedID
        }
        categoryAPICall(page: currentPage)
        //fetchData()
        self.toggleViewBtn.addTarget(self, action: #selector(toggleViewBtnTapped(sender:)), for: .touchUpInside)
        NotificationCenter.default
            .addObserver(self,
                         selector:#selector(filterSuccess(_:)),
                         name: NSNotification.Name ("Data"), object: nil)
        if seeAll == true{
            browseProdAPICall(page: currentPage)
        }
    }
    
    @objc func filterSuccess(_ notification: Notification){
        print((notification.userInfo?["userInfo"]!)! as? [String:Any] ?? [:])
        let notif = notification.userInfo?["userInfo"]! as? [String:Any] ?? [:]
        self.params = notif
        var str = String()
        if let minprice = notif["min_price"] as? String{
            str = "&min_price=\(minprice)"
        }
        if let maxprice = notif["max_price"] as? String{
            str = str + "&max_price=\(maxprice)"
        }
        if let categoryID = notif["category_id"] as? Int{
            self.categoryID = categoryID
        }
        if let brandID = notif["brand_id"] as? Int{
            str = str + "&brand_id=\(brandID)"
        }
        if let categoryName = notif["categoryName"] as? String{
            if selectedID != 0 {
                self.titleLabel.text = categoryName
            }
        }
        if let searchbarText = notif["search"] as? String{
            str = str + "&search=\(searchbarText)"
        }
        self.productsArr.removeAll()
        currentPage = 1
        categoryAPICall(page: currentPage)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandPKViewController") as! BrandPKViewController
        vc.category_Id = self.categoryID ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortingBtnTapped(_ sender: Any) {
        self.productsArr.removeAll()
        let alertController = UIAlertController()
        
        let popularity = UIAlertAction(title: "Popularity", style: .default) { (action: UIAlertAction!) in
            //let str = "&order_by=view_count&order_direction=desc"
            self.params["order_by"] = "view_count"
            self.params["order_direction"] = "desc"
            self.categoryAPICall(page: self.currentPage)
        }
        let lowToHigh = UIAlertAction(title: "Price Low - High", style: .default) { (action: UIAlertAction!) in
            //let str = "&order_by=price&order_direction=asc"
            self.params["order_by"] = "price"
            self.params["order_direction"] = "asc"
            self.categoryAPICall(page: self.currentPage)
        }
        let highToLow = UIAlertAction(title: "Price High - Low", style: .default) { (action: UIAlertAction!) in
            //let str = "&order_by=price&order_direction=desc"
            self.params["order_by"] = "price"
            self.params["order_direction"] = "desc"
            self.categoryAPICall(page: self.currentPage)
        }
        let productRating = UIAlertAction(title: "Product Rating", style: .default) { (action: UIAlertAction!) in
            //let str = "&order_by=rating&order_direction=desc"
            self.params["order_by"] = "rating"
            self.params["order_direction"] = "desc"
            self.categoryAPICall(page: self.currentPage)
        }
        let orderAtoZ = UIAlertAction(title: "Order A - Z", style: .default) { (action: UIAlertAction!) in
            //let str = "&order_by=title&order_direction=asc"
            self.params["order_by"] = "title"
            self.params["order_direction"] = "asc"
            self.categoryAPICall(page: self.currentPage)
        }
        let orderZtoA = UIAlertAction(title: "Order Z - A", style: .default) { (action: UIAlertAction!) in
            //let str = "&order_by=title&order_direction=desc"
            self.params["order_by"] = "title"
            self.params["order_direction"] = "desc"
            self.categoryAPICall(page: self.currentPage)
        }
        alertController.addAction(popularity)
        alertController.addAction(lowToHigh)
        alertController.addAction(highToLow)
        alertController.addAction(productRating)
        alertController.addAction(orderAtoZ)
        alertController.addAction(orderZtoA)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Check if running on iPad
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            // You can adjust the rect to your needs
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    @objc func toggleViewBtnTapped(sender: UIButton) {
        if toggleViewBtn.isSelected{
            
            //sender.isSelected = false
            toggleViewBtn.setImage(UIImage(systemName: "square.grid.3x2.fill"), for: .normal)
            toggleViewBtn.isSelected = false
            self.categoriesSimpleCV.isHidden = true
            self.categoriesGridCV.isHidden = false
        }
        else{
            
            //sender.isSelected = true
            toggleViewBtn.setImage(UIImage(systemName: "rectangle.grid.1x2.fill"), for: .normal)
            toggleViewBtn.isSelected = true
            self.categoriesGridCV.isHidden = true
            self.categoriesSimpleCV.isHidden = false
            
        }
        //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NextGirdCategoriesVC") as? NextGirdCategoriesVC
        //        vc?.selectedID = selectedID
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func categoryAPICall(page: Int) {
        
        guard let selectedID = self.selectedID else {
            print("No selected ID available.")
            return
        }
        var urlString = String()
        if isBrand ?? false{
//            urlString = base_url + "products?brand_id=\(selectedID)"
            //self.params["brand_id"] = selectedID
            urlString = base_url + "products?page=\(page)"
        }
        else{
//            urlString = base_url + "products?category_id=\(selectedID)" + sortingString
            //self.params["category_id"] = selectedID
            urlString = base_url + "products?page=\(page)"
        }
        Networking.instance.getApiCallWithParams(url: urlString, param: self.params){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary {
                    if body["totalItemCount"] != nil{
//                      self.totalItemCount = body["totalItemCount"] as! Int
                    }
                    if body["totalPages"] != nil{
                        self.totalPages = body["totalPages"]?.intValue ?? 0
                    }
                    if let res = body["response"]?.array{
                        print(res)
                        for dic in res{
                            let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                            self.productsArr.append(model)
                        }
                        if self.productsArr.isEmpty {
                            self.insdeCollectionView.isHidden = false
                        } else {
                            self.insdeCollectionView.isHidden = true
                        }
                        self.categoriesSimpleCV.reloadData()
                        self.categoriesGridCV.reloadData()
                    }
                }
            }
        }
    }
    
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
            if seeAll == true{
                browseProdAPICall(page: currentPage)
            }
            else{
                categoryAPICall(page: currentPage)
            }
        }
    }
    
    func browseProdAPICall(page: Int){
        //self.productsArr.removeAll()
            let url = base_url + "products?label=\(prodAttribute ?? "")&page=\(page)"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary {
                    if body["totalItemCount"] != nil{
                        //                              self.totalItemCount = body["totalItemCount"] as! Int
                    }
                    if body["totalPages"] != nil{
                        self.totalPages = body["totalPages"]?.intValue ?? 0
                    }
                    if let res = body["response"]?.array{
                        print(res)
                        for dic in res{
                            
                            let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                            self.productsArr.append(model)
                            self.categoriesSimpleCV.reloadData()
                            self.categoriesGridCV.reloadData()
                            
                        }
                        if self.productsArr.isEmpty {
                            self.insdeCollectionView.isHidden = false
                        } else {
                            self.insdeCollectionView.isHidden = true
                        }
                    }
                }
            }
            else{
                print("Error calling API")
            }
        }
    }
    @objc func heartBtnTapped(sender: UIButton){
            let id = productsArr[sender.tag].id ?? 0
            WishList.wishListAPICall(id: id){(complete) in
                if complete == true{
                    if self.productsArr[sender.tag].hasWishlist!{
                        if self.traitCollection.userInterfaceStyle == .dark {
                            sender.setImage(UIImage(systemName: "heart"), for: .normal)
                            sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        } else {
                            sender.setImage(UIImage(systemName: "heart"), for: .normal)
                            sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        }
                        self.productsArr[sender.tag].hasWishlist = false
                    }
                    else{
                        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                        print("added in recent")
                        self.productsArr[sender.tag].hasWishlist = true
                    }
                    
                }
                else{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
}
extension CategoriesNextVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesGridCV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriescell", for: indexPath) as! collectioncell
            let product = productsArr[indexPath.item]
            cell.titleLbl.text = product.catagorylabel
            
            let salePrice = (product.sale_price as NSString).integerValue
            let price = (product.price as NSString).integerValue
            if salePrice == price{
                cell.oldPriceLbl.isHidden = true
                cell.newPriceLbl.text = product.sale_price
            }
            else{
                cell.oldPriceLbl.isHidden = false
                cell.newPriceLbl.text = product.sale_price
                let attributedString = NSAttributedString(string: product.price, attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue])
                cell.oldPriceLbl.attributedText = attributedString
            }
            if product.featured == 1{
                cell.featureLbl.text = "Featured"
            }
            else if product.sponsored == 1{
                cell.featureLbl.text = "Sponsored"
            }
            else if product.newLabel == 1{
                cell.featureLbl.text = "New"
            }
            else if product.hotLabel == 1{
                cell.featureLbl.text = "Hot"
            }
            else if product.saleLabel == 1{
                cell.featureLbl.text = "Sale"
            }
            else if product.specialLabel == 1{
                cell.featureLbl.text = "Special"
            }
            if product.hasWishlist == true{
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
            cell.productImg.setImage(with: product.catagoryimage)
            cell.cosmosRating.settings.fillMode = .precise
            cell.cosmosRating.rating = product.rating ?? 0
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            cell.featureLbl.clipsToBounds = true
            cell.featureLbl.layer.cornerRadius = 8
            cell.featureLbl.layer.maskedCorners = [.layerMaxXMaxYCorner]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NextGridCollectionViewCell
            let product = productsArr[indexPath.item]
            cell.titleLbl.text = product.catagorylabel
            cell.rsLbl.text = product.price
            cell.imgView.setImage(with: product.catagoryimage)
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            if product.hasWishlist == true{
                cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.favBtn.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            }
            else {
                if traitCollection.userInterfaceStyle == .dark {
                    cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.favBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.favBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
            cell.cosmosView.settings.fillMode = .precise
            cell.cosmosView.rating = product.rating ?? 0
            cell.favBtn.tag = indexPath.item
            cell.favBtn.addTarget(self, action: #selector(heartBtnTapped(sender:)), for: .touchUpInside)
            //            cell.cosmosView.settings.fillMode = .precise
            //            cell.cosmosView.rating = product.
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesGridCV{
            return CGSize(width: 160, height: 268)
        }
        else{
            return CGSize(width: 358, height: 175)
        }
        //return CGSize(width: 158, height: 305)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = productsArr[indexPath.item] // Get the selected product
        let selectedID = selectedProduct.id
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC else {
            return
        }
        nextViewController.selectedResponseID = selectedID
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
