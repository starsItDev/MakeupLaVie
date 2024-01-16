//
//  ProductDetailsVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 19/04/2023.
//
import UIKit
import Cosmos

class ProductDetailsVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet var mainImgA: UIImageView!
    @IBOutlet var mainImgB: UIImageView!
    @IBOutlet var mainImgC: UIImageView!
    @IBOutlet var mainImgD: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet weak var rsLbl: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var addCartBtn: UIButton!
    @IBOutlet weak var countlbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet weak var wishListBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    var selectedIndex: Int?
    private var viewModel = MianHomeViewModel()
    var wishlistproducts: [ResponseWishlist] = []
    var params = [String: Any]()
    var hasCartItem = false
    var hasWishList = false
    var selectedResponseID: Int?
    private var responseID: Int?
    var responseIds: [Int] = []
    var selectedIDResponse: Int?
    var similarProductsArr = [ViewProductBody]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
        configuration()
        updateAddCartButtonText()
    }
    
    func updateAddCartButtonText() {
        if wishlistproducts.first(where: { $0.id == selectedResponseID })?.hasCartItem == true {
            addCartBtn.setTitle("REMOVE FROM CART", for: .normal)
        } else {
            addCartBtn.setTitle("ADD TO CART", for: .normal)
        }
    }
    @IBAction func addCartBtnPressed(_ sender: UIButton) {
        if self.hasCartItem{
            self.addCartBtn.setTitle("ADD TO CART", for: .normal)
            cartUpdateAPI()
        }
        else {
            cartUpdateAPI()
            self.addCartBtn.setTitle("REMOVE FROM CART", for: .normal)
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[3]
                if tabItem.badgeValue == nil{
                    tabItem.badgeValue = "1"
                }
                else{
                    var newBadgeValue = Int(tabItem.badgeValue ?? "")
                    newBadgeValue = (newBadgeValue ?? 0) + 1
                    tabItem.badgeValue = "\(newBadgeValue ?? 0)"
                }
            }
        }
    }
    
    @IBAction func compareBtnTapped(_ sender: Any) {
        compareAPI()
    }
    
    @IBAction func wishListBtnTapped(_ sender: Any) {
        wishListAPI()
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        
    }
    func cartUpdateAPI() {
        let url = base_url + "cart/update"
        params["id"] = self.responseID
        params["quantity"] = countlbl.text
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary{
                    let message = body["message"]?.string ?? ""
                    print("\(message)")
                }
            }
            else{
                let errorCode = response["error_code"].string
                if errorCode == "unauthorized"{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func compareAPI(){
        let url = base_url + "compare"
        params["id"] = self.responseID
        Networking.instance.postApiCall(url: url, param: params){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let status = response["status_code"].int{
                    utilityFunctions.showAlertWithTitle(title: "", withMessage: "Compare List Updated", withNavigation: self)
                }
            }
            else{
                let errorCode = response["error_code"].string
                if errorCode == "unauthorized"{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                print(error)
            }
        }
    }
    
    func wishListAPI(){
        WishList.wishListAPICall(id: self.responseID ?? 0){(complete) in
            if complete{
                if self.hasWishList{
                    self.wishListBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.wishListBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                else{
                    self.wishListBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.wishListBtn.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                }
            }
            else{
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func Addclick(_ sender: UIButton) {
        var value = Int(self.countlbl.text!) ?? 0
        value += 1
        self.countlbl.text = String(describing: value)
        //cartUpdateAPI(selectedID: responseID, quantity: String(value))
    }
    
    
    @IBAction func minusclick(_ sender: UIButton) {
        var value = Int(self.countlbl.text!) ?? 0
        value -= 1
        self.countlbl.text = String(describing: value)
        //cartUpdateAPI(selectedID: responseID, quantity: String(value))
    }
    
    
    //    @IBAction func Addclick(_ sender: UIButton){
    //        let value = Int(self.countlbl.text!)
    //        let newval = value! + 1
    //        self.countlbl.text = String(describing: newval)
    //
    //    }
    //    @IBAction func minusclick(_ sender: UIButton){
    //        let value = Int(self.countlbl.text!)
    //               let newval = value! - 1
    //               self.countlbl.text = String(describing: newval)
    //    }
    
    func apiCall() {
        guard let responseID = self.selectedResponseID else {
            print("No selected response ID available.")
            return
        }
        
        let urlString = "https://shop.plazauk.com/api/product/view/\(responseID)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(ViewProductModel.self, from: data)
                print(model)
                self.responseID = model.body.id
                DispatchQueue.main.async {
                    self.updateUI(with: model)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    func updateUI(with model: ViewProductModel) {
        titleLbl.text = model.body.title
        rsLbl.text = model.body.price
        let plainTextDescription = model.body.description.htmlToPlainText
        desLbl.text = plainTextDescription
        self.hasCartItem = model.body.hasCartItem
        print(model.body.hasCartItem)
        if self.hasCartItem{
            self.addCartBtn.setTitle("REMOVE FROM CART", for: .normal)
        }
        else{
            self.addCartBtn.setTitle("ADD TO CART", for: .normal)
        }
        
        self.hasWishList = model.body.hasWishlist
        if hasWishList{
            self.wishListBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.wishListBtn.tintColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        }
        else{
            self.wishListBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            self.wishListBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        mainImg.setImage(with: model.body.image)
        mainImgA.setImage(with: model.body.imageProfile)
        mainImgB.setImage(with: model.body.imageIcon)
        
        ratingView.settings.fillMode = .precise
        ratingView.rating = model.body.rating
        
        if let responseID = self.responseID {
            print("Response ID: \(responseID)")
        } else {
            print("No response ID available.")
        }
        self.similarProductsArr = model.body.similarProducts ?? []
        self.collectionView.reloadData()
    }
    
}


extension String {
    var htmlToPlainText: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}

extension ProductDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var totalItems = 0
//        for product in viewModel.products {
//            totalItems += product.body.recentProducts.count
//        }
//        return totalItems
        return similarProductsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailsCollectionCell
//        var currentIndex = 0
//        for product in viewModel.products {
//            let responseCount = product.body.recentProducts.count
//            if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
//                let itemIndex = indexPath.item - currentIndex
//                let specialOffer = product.body.recentProducts[itemIndex]
//                cell.titleLbl.text = product.body.recentProducts[itemIndex].title
//                cell.rsLbl.text = product.body.recentProducts[itemIndex].price
//                cell.img.setImage(with: product.body.recentProducts[itemIndex].image)
//
//                let responseId = specialOffer.id
//                responseIds.append(responseId)
//                break
//            }
//            currentIndex += responseCount
//        }
        let instance = similarProductsArr[indexPath.row]
        cell.titleLbl.text = instance.title
        cell.rsLbl.text = instance.price
        cell.img.setImage(with: instance.image)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 158, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = responseIds[indexPath.row]
        selectedIDResponse = selectedID
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC else {
            return
        }
        nextViewController.selectedResponseID = selectedID
        self.present(nextViewController, animated: true, completion: nil)
    }
}
extension ProductDetailsVC {
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
                print(error!)
            }
        }
    }
}
extension ProductDetailsVC {
    @IBAction func reviewBtn(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cornerRadiusPresent(_ sender: UIButton) {
        guard let image = mainImg.image else {
            return
        }
        let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        imageViewer.dismissCompletion = {
            // Optional: Perform any action after the image viewer is dismissed
        }
        present(imageViewer, animated: true, completion: nil)
    }
    @IBAction func cornerRadiusPresent1(_ sender: UIButton) {
        guard let image = mainImgA.image else {
            return
        }
        let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        imageViewer.dismissCompletion = {
        }
        present(imageViewer, animated: true, completion: nil)
        
    }
    @IBAction func cornerRadiusPresent2(_ sender: UIButton) {
        guard let image = mainImgB.image else {
            return
        }
        let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        imageViewer.dismissCompletion = {
            imageViewer.backgroundColor = UIColor(red: 12, green: 12, blue: 22, alpha: 2)
        }
        present(imageViewer, animated: true, completion: nil)
    }
    @IBAction func cornerRadiusPresent3(_ sender: UIButton) {
    }
    @IBAction func cornerRadiusPresent4(_ sender: UIButton) {
    }
}
