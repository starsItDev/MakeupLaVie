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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = selectedName
        categoryAPICall(sortingString: "")
        //fetchData()
        self.toggleViewBtn.addTarget(self, action: #selector(toggleViewBtnTapped(sender:)), for: .touchUpInside)
        NotificationCenter.default
            .addObserver(self,
                         selector:#selector(filterSuccess(_:)),
                         name: NSNotification.Name ("Data"), object: nil)
        if seeAll == true{
            browseProdAPICall()
        }
    }
    @objc func filterSuccess(_ notification: Notification){
        print((notification.userInfo?["userInfo"]!)! as? [String:Any] ?? [:])
        let notif = notification.userInfo?["userInfo"]! as? [String:Any] ?? [:]
        var str = String()
        if let minprice = notif["min_price"] as? String{
            str = "&min_price=\(minprice)"
        }
        if let maxprice = notif["max_price"] as? String{
            str = str + "&max_price=\(maxprice)"
        }
        if let categoryID = notif["category_id"] as? Int{
            selectedID = categoryID
        }
        if let brandID = notif["brand_id"] as? Int{
            str = str + "&brand_id=\(brandID)"
        }
        if let categoryName = notif["categoryName"] as? String{
            self.titleLabel.text = categoryName
        }
        if let searchbarText = notif["searchBarValue"] as? String{
            str = str + "&search=\(searchbarText)"
        }
        categoryAPICall(sortingString: str)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandPKViewController") as! BrandPKViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortingBtnTapped(_ sender: Any) {
        let alertController = UIAlertController()
        
        let popularity = UIAlertAction(title: "Popularity", style: .default) { (action: UIAlertAction!) in
            let str = "&order_by=view_count&order_direction=desc"
            self.categoryAPICall(sortingString: str)
        }
        let lowToHigh = UIAlertAction(title: "Price Low - High", style: .default) { (action: UIAlertAction!) in
            let str = "&order_by=price&order_direction=asc"
            self.categoryAPICall(sortingString: str)
        }
        let highToLow = UIAlertAction(title: "Price High - Low", style: .default) { (action: UIAlertAction!) in
            let str = "&order_by=price&order_direction=desc"
            self.categoryAPICall(sortingString: str)
        }
        let productRating = UIAlertAction(title: "Product Rating", style: .default) { (action: UIAlertAction!) in
            let str = "&order_by=rating&order_direction=desc"
            self.categoryAPICall(sortingString: str)
        }
        let orderAtoZ = UIAlertAction(title: "Order A - Z", style: .default) { (action: UIAlertAction!) in
            let str = "&order_by=title&order_direction=asc"
            self.categoryAPICall(sortingString: str)
        }
        let orderZtoA = UIAlertAction(title: "Order Z - A", style: .default) { (action: UIAlertAction!) in
            let str = "&order_by=title&order_direction=desc"
            self.categoryAPICall(sortingString: str)
        }
        alertController.addAction(popularity)
        alertController.addAction(lowToHigh)
        alertController.addAction(highToLow)
        alertController.addAction(productRating)
        alertController.addAction(orderAtoZ)
        alertController.addAction(orderZtoA)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func toggleViewBtnTapped(sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            toggleViewBtn.setImage(UIImage(systemName: "square.grid.3x2.fill"), for: .normal)
            self.categoriesSimpleCV.isHidden = true
            self.categoriesGridCV.isHidden = false
        }
        else{
            
            sender.isSelected = true
            toggleViewBtn.setImage(UIImage(systemName: "rectangle.grid.1x2.fill"), for: .normal)
            self.categoriesGridCV.isHidden = true
            self.categoriesSimpleCV.isHidden = false
            
        }
        //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NextGirdCategoriesVC") as? NextGirdCategoriesVC
        //        vc?.selectedID = selectedID
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func categoryAPICall(sortingString: String) {
        self.productsArr.removeAll()
        guard let selectedID = self.selectedID else {
            print("No selected ID available.")
            return
        }
        let urlString = "https://shop.plazauk.com/api/products?category_id=\(selectedID)" + sortingString
        Networking.instance.getApiCall(url: urlString){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary {
                    if body["totalItemCount"] != nil{
                        //                              self.totalItemCount = body["totalItemCount"] as! Int
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
        }
    }
    
    func browseProdAPICall(){
        self.productsArr.removeAll()
        let url = base_url + "products?\(prodAttribute ?? "")=1"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary {
                    if body["totalItemCount"] != nil{
                        //                              self.totalItemCount = body["totalItemCount"] as! Int
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
            
            cell.productImg.setImage(with: product.catagoryimage)
            cell.cosmosRating.settings.fillMode = .precise
            cell.cosmosRating.rating = product.rating ?? 0
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NextGridCollectionViewCell
            let product = productsArr[indexPath.item]
            cell.titleLbl.text = product.catagorylabel
            cell.rsLbl.text = product.price
            cell.imgView.setImage(with: product.catagoryimage)
            //            cell.cosmosView.settings.fillMode = .precise
            //            cell.cosmosView.rating = product.
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesGridCV{
            return CGSize(width: UIScreen.main.bounds.width/2 - 15, height: 250)
        }
        else{
            return CGSize(width: 330, height: 220)
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
