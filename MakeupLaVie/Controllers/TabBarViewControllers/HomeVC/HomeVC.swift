//
//  HomeVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 17/04/2023.
//

import UIKit
import SDWebImage

//class HomeVC: UIViewController, CollectionViewCellDelegate ,CollectionViewCellDelegate2 {
class HomeVC: UIViewController {
    // MARK: - OutLets
    @IBOutlet weak var specialOfferCV: UICollectionView!
    @IBOutlet weak var hotProductCV: UICollectionView!
    @IBOutlet weak var bestProductCV: UICollectionView!
    @IBOutlet weak var featureBrandView: UIView!
    @IBOutlet weak var featureBrandCV: UICollectionView!
    @IBOutlet weak var newProductCV: UICollectionView!
    @IBOutlet weak var recentProductCV: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var drawerTableView: UITableView!
    @IBOutlet var myPageControl: UIPageControl!
    @IBOutlet var pagerCollectionView: UICollectionView!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var sideBarView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingImageView: UIView!
    @IBOutlet weak var featureBrandViewHeight: NSLayoutConstraint!
    
    // MARK: - Variable
    var isHeartButtonEnabled = true
    private let refreshControl = UIRefreshControl()
    var inWishlist = false
    var isSideViewOpen: Bool = false
    var timer: Timer?
    var currentIndex = 0
    var makeUPImageControl:[String] = ["bg-promotion-1","bg-promotion-2","bg-promotion-3","bg-promotion-4","bg-promotion-5","bg-promotion-6"]
    private var viewModel = HomeViewModel()
    private var selectedID: Int?
    var counter = 0
    var namesArray = ["Home", "Search", "Products" , "Categories" , "WishList" , "CompareList", "Privacy Policy", "Login"]
    let imgArr = ["home","search","bag","menu","like", "recycle", "insurance","user"]
    
    var recentdataArray = [GenericListingModel]()
    var newproductArray = [GenericListingModel]()
    var bestproductArray = [GenericListingModel]()
    var hotproductArray = [GenericListingModel]()
    var speciallproductArray = [GenericListingModel]()
    var categoryArray = [GenericListingModel]()
    var BrandArray = [GenericListingModel]()
    var mArray = [Int]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        let time = UserInfo.shared.expiresTime
        //let time = 15
        if UserInfo.shared.isUserLoggedIn == true{
            self.namesArray[7] = "Logout"
            var timerr = Timer()
            timerr = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(self.refreshTokenAPI), userInfo: nil, repeats: true)
            //refreshTokenAPI()
        }
        getCategoryAPI()
        getBrandAPI()
        homePageAPI()
        categoryCollectionView.reloadData()
        recentProductCV.reloadData()
        featureBrandCV.reloadData()
        newProductCV.reloadData()
        bestProductCV.reloadData()
        hotProductCV.reloadData()
        specialOfferCV.reloadData()
        sideBarView.isHidden = true
        isSideViewOpen = false
        setupViews()
        drawerTableView.reloadData()
        //lblName.text = strName
        myPageControl.currentPage = 0
        myPageControl.numberOfPages = makeUPImageControl.count
        
        DispatchQueue.main.async {
          self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        checkUserLoggedIn()
//        getCategoryAPI()
//        getBrandAPI()
//        homePageAPI()
//        categoryCollectionView.reloadData()
//        recentProductCV.reloadData()
//        featureBrandCV.reloadData()
//        newProductCV.reloadData()
//        bestProductCV.reloadData()
//        hotProductCV.reloadData()
//        specialOfferCV.reloadData()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl)
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - Helper Functions
    func setupViews(){
        self.navigationController?.isNavigationBarHidden = true
        sideBarView.clipsToBounds = true
        sideBarView.layer.cornerRadius = 20
        sideBarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    @objc private func refreshData() {
        if utilityFunctions.isConnectedToNetwork(){
            homePageAPI()
            getCategoryAPI()
            getBrandAPI()
            categoryCollectionView.reloadData()
            recentProductCV.reloadData()
            featureBrandCV.reloadData()
            newProductCV.reloadData()
            bestProductCV.reloadData()
            hotProductCV.reloadData()
            specialOfferCV.reloadData()
        }
        else{
            self.showToast(message: "Please check your internet connection")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.loadingView.isHidden = false
            self.loadingImageView.isHidden = false
        }
        refreshControl.endRefreshing()
    }
    
    @objc func changeImage(){
        if counter < makeUPImageControl.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.pagerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            myPageControl.currentPage = counter
            counter += 1
        }
        else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.pagerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            myPageControl.currentPage = counter
            
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func recentSeeAllBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
        vc.prodAttribute = "recent"
        vc.selectedName = "Recent Products"
        vc.seeAll = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func newSeeAllBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
        vc.prodAttribute = "new"
        vc.selectedName = "New Products"
        vc.seeAll = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func featureSeeAllBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandsVC") as! BrandsVC
//        vc.prodAttribute = "featured"
//        vc.selectedName = "Brands"
//        vc.seeAll = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bestSeeAllBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
        vc.prodAttribute = "best"
        vc.selectedName = "Best Products"
        vc.seeAll = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func hotProdSeeAllBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
        vc.prodAttribute = "hot"
        vc.selectedName = "Hot Products"
        vc.seeAll = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func specialSeeAllBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
        vc.prodAttribute = "special"
        vc.selectedName = "Special Products"
        vc.seeAll = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sideBarMenu(_ sender: UIButton) {
        
        //self.view.bringSubviewToFront(sideBarView)
        if !isSideViewOpen{
            sideBarView.isHidden = false
            isSideViewOpen = true
            shadowView.isHidden = false
            sideBarView.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
            UIView.setAnimationDuration(10.0)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sideBarView.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
            UIView.commitAnimations()
        }else{
            shadowView.isHidden = true
            sideBarView.isHidden = true
            isSideViewOpen = false
            sideBarView.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
            UIView.setAnimationDuration(10.0)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sideBarView.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
            UIView.commitAnimations()
        }
    }
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == shadowView{
            isSideViewOpen = false
            sideBarView.isHidden = true
            shadowView.isHidden = true
        }
    }
    
    func checkUserLoggedIn(){
        let url = base_url + "user/me"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if statusCode == 200 && error == nil{
                UserInfo.shared.isUserLoggedIn = true
            }
            else if statusCode == 401{
                UserInfo.logOut()
            }
        }
    }
    
    @objc func refreshTokenAPI(){
        print("----Timer-----")
        var params = [String:Any]()
        params["grant_type"] = "refresh_token"
        params["client_id"] = "2"
        params["client_secret"] = "YDAIQy9cKcL3fPifVF20eRBI0y9de2ab3UMr01KY"
        params["refresh_token"] = UserInfo.shared.refreshToken
        params["scope"] = ""
        print(params)
        let url = "\(base_url)token/refresh"
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            print(response)
            if statusCode == 200 && error == nil{
                let body = response["body"].dictionary
                let token_type = body?["token_type"]?.stringValue
                let expires_in = body?["expires_in"]?.intValue
                let access_token = body?["access_token"]?.stringValue
                let refresh_token = body?["refresh_token"]?.stringValue
                let user = body?["user"]?.dictionary
                let id = user?["id"]?.intValue
                let email = user?["email"]?.stringValue
                let first_name = user?["first_name"]?.stringValue
                let last_name = user?["last_name"]?.stringValue
                let created_at = user?["created_at"]?.stringValue
                let updated_at = user?["updated_at"]?.stringValue
                let locale = user?["locale"]?.stringValue
                let phone = user?["phone"]?.stringValue
                let userArr = [id ?? 0, first_name ?? "", last_name ?? "", email ?? "", true, access_token ?? "", refresh_token ?? "", expires_in ?? 0, token_type ?? "", phone ?? ""] as [Any]
                print(userArr)
                UserInfo.storeUserInfoArrayInInstance(array: userArr)
            }
            else{
                print(error)
                let message = response["message"].stringValue
                //utilityFunctions.showAlertWithTitle(title: "", withMessage: message, withNavigation: self)
                DispatchQueue.main.async {
                    UserInfo.logOut()
                    self.namesArray[7] = "Login"
                    self.drawerTableView.reloadData()
                }
                
            }
        }
    }
    
    func getCategoryAPI(){
        self.categoryArray.removeAll()
        let url = base_url + "categories"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil{
                if let body = response["body"].dictionary{
                    print(response)
                    if body["totalItemCount"] != nil{
                        //                              self.totalItemCount = body["totalItemCount"] as! Int
                    }
                    if let res = body["response"]?.array{
                        for dic in res{
                            
                            let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                            self.categoryArray.append(model)
                            self.categoryCollectionView.reloadData()
                            
                        }
                    }
                    
                }
            }
            else{
                print(error)
            }
        }
    }
    
    func getBrandAPI(){
        BrandArray.removeAll()
        let url = base_url + "brands"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil{
                
                if let body = response["body"].dictionary{
                    if body["totalItemCount"] != nil{
                        
                    }
                    if let res = body["response"]?.array{
                        if !res.isEmpty{
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.BrandArray.append(model)
                                self.featureBrandCV.reloadData()
                                self.featureBrandView.isHidden = false
                                self.featureBrandCV.isHidden = false
                                self.featureBrandViewHeight.constant = 90
                                
                            }
                        }
                        else{
                            self.featureBrandView.isHidden = true
                            self.featureBrandCV.isHidden = true
                            self.featureBrandViewHeight.constant = 0
                        }
                    }
                    
                }
            }
            else{
                print(error)
            }
        }
    }
    
    func homePageAPI() {
        recentdataArray.removeAll()
        newproductArray.removeAll()
        bestproductArray.removeAll()
        hotproductArray.removeAll()
        speciallproductArray.removeAll()
        if utilityFunctions.isConnectedToNetwork() {
        let url = base_url + "home"
            Networking.instance.getApiCall(url: url){(response, error, statusCode) in
                if error == nil && statusCode == 200{
                    self.loadingView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    if let body = response["body"].dictionary {
                        //print(response)
                        if body["totalItemCount"] != nil{
                            //                              self.totalItemCount = body["totalItemCount"] as! Int
                        }
                        if let res = body["recentProducts"]?.array{
                            print(res)
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.recentdataArray.append(model)
                                
                            }
                            self.recentProductCV.reloadData()
                        }
                        if let res = body["newProducts"]?.array{
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.newproductArray.append(model)
                                
                            }
                            self.newProductCV.reloadData()
                        }
                        if let res = body["bestProducts"]?.array{
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.bestproductArray.append(model)
                                
                            }
                            self.bestProductCV.reloadData()
                        }
                        if let res = body["hotDeals"]?.array{
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.hotproductArray.append(model)
                                
                            }
                            self.hotProductCV.reloadData()
                        }
                        if let res = body["specialOffers"]?.array{
                            for dic in res{
                                
                                let model = GenericListingModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                                self.speciallproductArray.append(model)
                                
                            }
                            self.specialOfferCV.reloadData()
                        }
                    }
                }else if statusCode == 500{
                    utilityFunctions.showAlertWithTitle(title: "", withMessage: "Server Error", withNavigation: self)
                }
                else {
                    print(error)
                }
            }
        }
        else {
            self.showToast(message: "Please check your internet connection")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.loadingView.isHidden = false
            self.loadingImageView.isHidden = false
        }
    }

    @objc func recentHeartBtnTapped(sender: UIButton) {
        // Disable the button to prevent multiple clicks
        if !isHeartButtonEnabled {
            return
        }

        isHeartButtonEnabled = false

        let id = recentdataArray[sender.tag].id ?? 0
        WishList.wishListAPICall(id: id) { (complete) in
            // Enable the button after the API call is completed or after some action
            defer {
                self.isHeartButtonEnabled = true
            }

            if complete {
                if self.recentdataArray[sender.tag].hasWishlist! {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    self.recentdataArray[sender.tag].hasWishlist = false
                } else {
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                    print("added in recent")
                    self.recentdataArray[sender.tag].hasWishlist = true
                }
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func newHeartBtnTapped(sender: UIButton){
        let id = newproductArray[sender.tag].id ?? 0
        WishList.wishListAPICall(id: id){(complete) in
            if complete == true{
                if self.newproductArray[sender.tag].hasWishlist!{
                    if self.traitCollection.userInterfaceStyle == .dark {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    self.newproductArray[sender.tag].hasWishlist = false
                }
                else{
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                    print("added in recent")
                    self.newproductArray[sender.tag].hasWishlist = true
                }
                
            }
            else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func bestHeartBtnTapped(sender: UIButton){
        let id = bestproductArray[sender.tag].id ?? 0
        WishList.wishListAPICall(id: id){(complete) in
            if complete == true{
                if self.bestproductArray[sender.tag].hasWishlist!{
                    if self.traitCollection.userInterfaceStyle == .dark {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    self.bestproductArray[sender.tag].hasWishlist = false
                }
                else{
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                    print("added in recent")
                    self.bestproductArray[sender.tag].hasWishlist = true
                }
                
            }
            else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func hotHeartBtnTapped(sender: UIButton){
        let id = hotproductArray[sender.tag].id ?? 0
        WishList.wishListAPICall(id: id){(complete) in
            if complete == true{
                if self.hotproductArray[sender.tag].hasWishlist!{
                    if self.traitCollection.userInterfaceStyle == .dark {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    self.hotproductArray[sender.tag].hasWishlist = false
                }
                else{
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                    print("added in recent")
                    self.hotproductArray[sender.tag].hasWishlist = true
                }
                
            }
            else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func specialHeartBtnTapped(sender: UIButton){
        let id = speciallproductArray[sender.tag].id ?? 0
        WishList.wishListAPICall(id: id){(complete) in
            if complete == true{
                if self.speciallproductArray[sender.tag].hasWishlist!{
                    if self.traitCollection.userInterfaceStyle == .dark {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        sender.setImage(UIImage(systemName: "heart"), for: .normal)
                        sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    self.speciallproductArray[sender.tag].hasWishlist = false
                }
                else{
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                    print("added in recent")
                    self.speciallproductArray[sender.tag].hasWishlist = true
                }
                
            }
            else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - Table View
extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == drawerTableView{
            return namesArray.count
        }
        else{
            return 10
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == drawerTableView{
            let cell = drawerTableView.dequeueReusableCell(withIdentifier: "DashBoardCell", for: indexPath) as! DashBoardCell

            cell.itemname.text = namesArray[indexPath.row]
            cell.imgview.image = UIImage(named: imgArr[indexPath.row])
            return cell
        }
        else{
//            switch indexPath.row {
//            case 0:
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell", for: indexPath) as? TrendingTableViewCell {
//                    cell.delegate = self
//                    return cell
//                }
//            case 1:
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewInsideTableViewCell", for: indexPath) as? CollectionViewInsideTableViewCell{
//                    cell.delegate = self
//                    return cell
//                }
//            case 2:
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialTableView", for: indexPath) as? SpecialTableView {
//                    cell.delegate = self
//                    return cell
//                }
//            case 3:
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "BestProductsTableView", for: indexPath) as? BestProductsTableView {
//                    cell.delegate = self
//                    return cell
//                }
//            case 4:
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "HotDealTableView", for: indexPath) as? HotDealTableView {
//                    cell.delegate = self
//                    return cell
//                }
//
//            default:
//                break
//            }
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == drawerTableView{
            if indexPath.row == 0{
                self.sideBarView.isHidden = true
                self.shadowView.isHidden = true
            }
            else if indexPath.row == 1{
                self.tabBarController?.selectedIndex = 2
            }
            else if indexPath.row == 2{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WishListVC") as? WishListVC
                vc?.isWishList = false
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else if indexPath.row == 3{
                self.tabBarController?.selectedIndex = 1
            }
            else if indexPath.row == 4{
                if UserInfo.shared.isUserLoggedIn{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WishListVC") as? WishListVC
                    self.tabBarController?.tabBar.isHidden = true
                    vc?.isWishList = true
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if indexPath.row == 5{
                if UserInfo.shared.isUserLoggedIn{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WishListVC") as? WishListVC
                    self.tabBarController?.tabBar.isHidden = true
                    vc?.isCompare = true
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if indexPath.row == 6{
                if let url = URL(string: "https://app.ecommercep.com/api/help/privacy"){
                    UIApplication.shared.open(url)
                }
            }
            else if indexPath.row == 7{
                if UserInfo.shared.isUserLoggedIn == true{
                    UserInfo.logOut()
                    self.namesArray[7] = "Login"
                    viewDidLoad()
                }
                else{

                    self.tabBarController?.tabBar.isHidden = true
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
            self.sideBarView.isHidden = true
            self.shadowView.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == drawerTableView{

        }
        else{
            switch indexPath.row {
            case 0:
                return 155
            case 1,2,3,4:
                return 450
            default:
                break
            }}
        return 40

    }
//
//    func didSelectItemAtIndex(index: Int, selectedID: Int) {
//        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//        destinationVC.selectedIndex = index
//        destinationVC.selectedResponseID = selectedID
//        navigationController?.pushViewController(destinationVC, animated: true)
//    }
//
//    func didSelectItemAtIndex2(index: Int ,selectedID: Int) {
//        print("ALL IS WELL")
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
//        //vc.selectedIndex = index
//        vc.selectedID = selectedID
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
//
//
}

// MARK: - Collection View
extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pagerCollectionView{
            return makeUPImageControl.count
        }
        else if collectionView == categoryCollectionView{
            print(categoryArray.count)
            return categoryArray.count
        }
        else if collectionView == recentProductCV{
            return recentdataArray.count
        }
        else if collectionView == newProductCV{
            return newproductArray.count
        }
        else if collectionView == featureBrandCV{
            return BrandArray.count
        }
        else if collectionView == bestProductCV{
            return bestproductArray.count
        }
        else if collectionView == hotProductCV{
            return hotproductArray.count
        }
        else{
            return speciallproductArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == pagerCollectionView{
            let cell = pagerCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PageControlCollectionViewCell
            print(makeUPImageControl[indexPath.item])
            cell.myWebView.image = UIImage(named: makeUPImageControl[indexPath.item])
            cell.layer.cornerRadius = 30
            cell.clipsToBounds = true
            cell.myWebView.sizeToFit()
            
            return cell
        }
        else if collectionView == categoryCollectionView{
            
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell1", for: indexPath) as! collectioncell
            cell.catagoryimage.setImage(with: categoryArray[indexPath.item].catagoryimage)
            cell.catagoryimage.layer.cornerRadius = 40
            cell.catagoryimage.layer.borderWidth = 2
            cell.catagoryimage.layer.borderColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            cell.catagorynames.text = categoryArray[indexPath.item].catagorylabel
            //            return cell
            print("collectionview 2")
            return cell
        }
        else if collectionView == recentProductCV{
            let cell = recentProductCV.dequeueReusableCell(withReuseIdentifier: "recentcell", for: indexPath)  as! collectioncell
            let instance = recentdataArray[indexPath.item]
            cell.productImg.setImage(with: instance.catagoryimage)
            
            //cell.addToCartBtn.accessibilityIdentifier = "recent"
            //cell.addToCartBtn.tag = indexPath.item
            //cell.addToCartBtn.addTarget(self, action: #selector(AddtoCart(_:)), for: UIControl.Event.touchUpInside)
            
            
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
            else{
                if traitCollection.userInterfaceStyle == .dark {
                    cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.heartBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    cell.heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.heartBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
            
            cell.heartBtn.tag = indexPath.item
            cell.heartBtn.addTarget(self, action: #selector(recentHeartBtnTapped(sender:)), for: .touchUpInside)
            
            cell.cosmosRating.settings.fillMode = .precise
            cell.cosmosRating.rating = instance.rating ?? 0
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
        }
        else if collectionView == featureBrandCV{
            let cell = featureBrandCV.dequeueReusableCell(withReuseIdentifier: "brandcell", for: indexPath) as! collectioncell
            cell.brandimg.setImage(with: BrandArray[indexPath.row].catagoryimage)
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
        }
        else if collectionView == newProductCV{
            let cell = newProductCV.dequeueReusableCell(withReuseIdentifier: "newproductcell", for: indexPath) as! collectioncell
            
            let instance = newproductArray[indexPath.item]
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
            cell.heartBtn.addTarget(self, action: #selector(newHeartBtnTapped(sender:)), for: UIControl.Event.touchUpInside)
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
            
            cell.cosmosRating.settings.fillMode = .precise
            cell.cosmosRating.rating = instance.rating ?? 0
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
            
        }
        else if collectionView == bestProductCV{
            let cell = bestProductCV.dequeueReusableCell(withReuseIdentifier: "bestproductcell", for: indexPath) as! collectioncell
            let instance = bestproductArray[indexPath.item]
            cell.addToCartBtn.accessibilityIdentifier = "best"
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
            cell.heartBtn.addTarget(self, action: #selector(bestHeartBtnTapped(sender:)), for: UIControl.Event.touchUpInside)
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
            
            cell.cosmosRating.settings.fillMode = .precise
            cell.cosmosRating.rating = instance.rating ?? 0
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
        }
        else if collectionView == specialOfferCV{
            let cell = specialOfferCV.dequeueReusableCell(withReuseIdentifier: "speciallproductcell", for: indexPath) as! collectioncell
            let instance = speciallproductArray[indexPath.item]
            cell.addToCartBtn.accessibilityIdentifier = "speciall"
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
            cell.heartBtn.addTarget(self, action: #selector(specialHeartBtnTapped(sender:)), for: UIControl.Event.touchUpInside)
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
            
            cell.cosmosRating.settings.fillMode = .precise
            cell.cosmosRating.rating = instance.rating ?? 0
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
            
        }
        
        else{
            let instance = hotproductArray[indexPath.item]
            let cell = hotProductCV.dequeueReusableCell(withReuseIdentifier: "hotproductcell", for: indexPath) as! collectioncell
            cell.addToCartBtn.accessibilityIdentifier = "hot"
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
            cell.heartBtn.addTarget(self, action: #selector(hotHeartBtnTapped(sender: )), for: UIControl.Event.touchUpInside)
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
            
            cell.cosmosRating.settings.fillMode = .precise
            cell.cosmosRating.rating = instance.rating ?? 0
            cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        if collectionView == recentProductCV{
            destinationVC.selectedResponseID = recentdataArray[indexPath.item].id
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        if collectionView == newProductCV{
            destinationVC.selectedResponseID = newproductArray[indexPath.item].id
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
        if collectionView == bestProductCV{
            destinationVC.selectedResponseID = bestproductArray[indexPath.item].id
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        if collectionView == hotProductCV{
            destinationVC.selectedResponseID = hotproductArray[indexPath.item].id
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        if collectionView == specialOfferCV{
            destinationVC.selectedResponseID = speciallproductArray[indexPath.item].id
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        if collectionView == categoryCollectionView{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
            vc.selectedID = categoryArray[indexPath.item].id
            vc.selectedName = categoryArray[indexPath.item].catagorylabel
            self.tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == featureBrandCV{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
            vc.selectedID = BrandArray[indexPath.item].id
            vc.selectedName = BrandArray[indexPath.item].catagorylabel
            vc.isBrand = true
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == pagerCollectionView{
            return CGSize(width: pagerCollectionView.bounds.width, height: 180)
        }
        if collectionView == categoryCollectionView{
            return CGSize(width: 87, height: 80)
        }
        else{
            return CGSize(width: 105, height: 130)
        }
    }
}

extension HomeVC {
    static func shareInstance() -> HomeVC {
        return HomeVC.instantiateFromStoryboard("Main")
    }
}
extension UIViewController{
    class func instantiateFromStoryboard(_ name: String ) -> Self
    {
        return instantiateFromStoryboardHelper(name)
    }
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T
    {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
}
extension UITabBarController {
    class func shareInstance() -> UITabBarController{
        return.instantiateFromStoryboardTabBar("Main")
    }
}
extension UITabBarController {
    class func instantiateFromStoryboardTabBar(_ name: String) -> Self {
        return instantiateFromStoryboardHelperTabBar(name)
    }
    fileprivate class func instantiateFromStoryboardHelperTabBar<T: UITabBarController>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
}
