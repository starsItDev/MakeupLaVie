import UIKit

class WishListVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var totalPages = -1
    var currentPage = 1
    var isWishList = false
    var isCompare = false
    var wishlistproductsArr: [GenericListingModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if isWishList{
            self.titleLbl.text = "WishList"
            let str = "wishlist"
            fetchData(str: str, page: currentPage)
        }
        else if isCompare{
            self.titleLbl.text = "Compare List"
            let str = "compare"
            fetchData(str: str, page: currentPage)
        }
        else{
            self.titleLbl.text = "Products"
            let str = "products"
            fetchData(str: str, page: currentPage)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchData(str: String, page: Int) {
        let url = base_url + "\(str)?page=\(page)"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil{
                if let body = response["body"].dictionary {
                    //print(response)
                    if body["totalItemCount"] != nil{
                        //                              self.totalItemCount = body["totalItemCount"] as! Int
                    }
                    if body["totalPages"] != nil{
                        self.totalPages = body["totalPages"]?.intValue ?? 1
                    }
                    if let res = body["response"]?.array{
                        for dic in res{
                            
                            let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                            self.wishlistproductsArr.append(model)
                            self.collectionView.reloadData()
                            
                        }
                    }
                }
            }
            else{
                print("someting went wrong")
                print("someting went wrong")
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
            if isWishList{
                let str = "wishlist"
                fetchData(str: str, page: currentPage)
            }
            else if isCompare{
                let str = "compare"
                fetchData(str: str, page: currentPage)
            }
            else{
                let str = "products"
                fetchData(str: str, page: currentPage)
            }
        }
    }
    
    @objc func heartBtnTapped(sender: UIButton){
        let id = wishlistproductsArr[sender.tag].id ?? 0
        WishList.wishListAPICall(id: id){(complete) in
            if complete == true{
                if self.isWishList{
                    if self.wishlistproductsArr[sender.tag].hasWishlist!{
                        
//                        self.wishlistproductsArr[sender.tag].hasWishlist = false
                        self.wishlistproductsArr.remove(at: sender.tag)
                        self.collectionView.reloadData()
                        
                    }
                    else{
                        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                        print("added in recent")
                        self.wishlistproductsArr[sender.tag].hasWishlist = true
                    }
                }
                else{
                    if self.wishlistproductsArr[sender.tag].hasWishlist!{
                        if self.traitCollection.userInterfaceStyle == .dark {
                            sender.setImage(UIImage(systemName: "heart"), for: .normal)
                            sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        } else {
                            sender.setImage(UIImage(systemName: "heart"), for: .normal)
                            sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        }
//                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
//                        sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        self.wishlistproductsArr[sender.tag].hasWishlist = false
                    }
                    else{
                        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                        print("added in recent")
                        self.wishlistproductsArr[sender.tag].hasWishlist = true
                    }
                }
            }
        }
    }
}

extension WishListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistproductsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productcell", for: indexPath) as! collectioncell
        
        let instance = wishlistproductsArr[indexPath.item]
        if isCompare{
            cell.heartBtn.isHidden = true
        }
        cell.addToCartBtn.accessibilityIdentifier = "new"
        cell.addToCartBtn.tag = indexPath.row
        //cell.addToCartBtn.addTarget(self, action: #selector(AddtoCart(_:)), for: UIControl.Event.touchUpInside)
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
        
        
        cell.heartBtn.tag = indexPath.item
        //cell.heartBtn.addTarget(self, action: #selector(newHeartBtnTapped(sender:)), for: UIControl.Event.touchUpInside)
        if instance.hasWishlist == true{
            
            cell.heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.heartBtn.tintColor = #colorLiteral(red: 0.9991409183, green: 0.2293452919, blue: 0.188941747, alpha: 1)
            cell.heartBtn.isSelected = true
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
        cell.heartBtn.addTarget(self, action: #selector(heartBtnTapped(sender: )), for: .touchUpInside)
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
        destinationVC.selectedResponseID = wishlistproductsArr[indexPath.item].id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.width/2 - 15, height: 250)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 250)
    }

}
