//
//  ProductDetailsVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 19/04/2023.
//
import UIKit
import Cosmos

class ProductDetailsVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet weak var rsLbl: UILabel!
    //@IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var addCartBtn: UIButton!
    @IBOutlet weak var countlbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet weak var wishListBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var productImageCollectionView: UICollectionView!
    @IBOutlet weak var productTwoImageCollectionView: UICollectionView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
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
    var photosArr = [Photo]()
    var selectedIndexPath: IndexPath?
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        apiCall()
        configuration()
        updateAddCartButtonText()
    }
    
    //MARK: - Helper Functions
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
            if UserInfo.shared.isUserLoggedIn {
                self.addCartBtn.setTitle("REMOVE FROM CART", for: .normal)
                if let tabItems = tabBarController?.tabBar.items {
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
                if response["status_code"].int != nil{
                    utilityFunctions.showAlertWithTitle(title: "", withMessage: "Compare List Updated", withNavigation: self)
                }
            }
            else{
                let errorCode = response["error_code"].string
                if errorCode == "unauthorized"{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                print(error ?? "")
            }
        }
    }
    func wishListAPI(){
        WishList.wishListAPICall(id: self.responseID ?? 0){(complete) in
            if complete{
                if self.hasWishList{
                    self.wishListBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    //self.wishListBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
    @objc func apiCall() {
        guard let responseID = self.selectedResponseID else {
            print("No selected response ID available.")
            return
        }
        let urlString = base_url + "product/view/\(responseID)"
        
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
                    self.loadingView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
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
        //desLbl.text = plainTextDescription
        descTextView.text = plainTextDescription
        descTextView.sizeToFit()
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
            //self.wishListBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        ratingView.settings.fillMode = .precise
        ratingView.rating = model.body.rating
        if let responseID = self.responseID {
            print("Response ID: \(responseID)")
        } else {
            print("No response ID available.")
        }
        self.similarProductsArr = model.body.similarProducts ?? []
        self.photosArr = model.body.photos ?? []
        self.productCollectionView.reloadData()
        self.productImageCollectionView.reloadData()
        self.productTwoImageCollectionView.reloadData()
    }
}

//MARK: - Extension String
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

//MARK: - Extension ProductDetailsVC
extension ProductDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView {
            return similarProductsArr.count
        }
        else if collectionView == productImageCollectionView {
            return photosArr.count
        }
        else if collectionView == productTwoImageCollectionView {
            return photosArr.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailsCollectionCell
            let instance = similarProductsArr[indexPath.row]
            cell.titleLbl.text = instance.title
            cell.rsLbl.text = instance.price
            cell.img.setImage(with: instance.image)
            cell.cosmosView.settings.fillMode = .precise
            cell.cosmosView.rating = instance.rating
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            return cell
        } else if collectionView == productImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductImageCollectionViewCell
            cell.productImage.setImage(with:photosArr[indexPath.row].thumbProfile)
            cell.productImage.sizeToFit()
            return cell
        }
        else if collectionView == productTwoImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductTwoImageCollectionCell
            cell.productTwoImage.setImage(with: photosArr[indexPath.row].thumbIcon)
            cell.layer.borderWidth = 1
            if indexPath.item == 0{
                cell.layer.borderColor = UIColor.red.cgColor
                cell.layer.cornerRadius = 3
                selectedIndexPath = indexPath
            }
            else{
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.layer.cornerRadius = 3
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == productCollectionView {
//            return CGSize(width: 158, height: 230)
//        }
//        else if collectionView == productImageCollectionView {
//            return CGSize(width: self.view.bounds.width, height: 170)
//        }
//        else if collectionView == productTwoImageCollectionView {
//            return CGSize(width: 50, height: 50)
//        }
//        return CGSize(width: 0, height: 0)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCollectionView {
            let selectedID = similarProductsArr[indexPath.row].id
            selectedIDResponse = selectedID
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC else {
                return
            }
            nextViewController.selectedResponseID = selectedID
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else if collectionView == productImageCollectionView {
            showImageSlider(at: indexPath.item)
        }
        else if collectionView == productTwoImageCollectionView {
            if let previousSelectedIndexPath = selectedIndexPath {
                        if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? ProductTwoImageCollectionCell {
                            previousSelectedCell.layer.borderColor = UIColor.lightGray.cgColor
                        }
                    }

                    // Update the selected cell
                    if let selectedCell = collectionView.cellForItem(at: indexPath) as? ProductTwoImageCollectionCell {
                        selectedCell.layer.borderColor = UIColor.red.cgColor
                        selectedIndexPath = indexPath
                    }
            didSelectProductTwoImage(at: indexPath)
        }
    }
    
    func didSelectProductTwoImage(at indexPath: IndexPath) {
        let selectedImage = photosArr[indexPath.row]
        if let index = photosArr.firstIndex(where: { $0.thumbMain == selectedImage.thumbMain }) {
            let newIndex = IndexPath(item: index, section: 0)
            self.productImageCollectionView.scrollToItem(at: newIndex, at: .centeredHorizontally, animated: true)
        }
    }
    func showImageSlider(at index: Int) {
        let imageSliderVC = ImageSliderViewController()
        imageSliderVC.images = photosArr
        imageSliderVC.currentIndex = index
        let navigationController = UINavigationController(rootViewController: imageSliderVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

//MARK: - Extension ProductDetailsVC
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
                    self.productCollectionView.reloadData()
                }
            case .error(let error):
                print(error!)
            }
        }
    }
}

//MARK: - Extension ProductDetailsVC
extension ProductDetailsVC {
    @IBAction func reviewBtn(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Classe ImageSliderViewController
class ImageSliderViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var images: [Photo] = []
    var currentIndex: Int?
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "white-gray")
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = closeButton
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = currentIndex ?? 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        if let index = currentIndex, index >= 0, index < images.count {
            let initialVC = viewControllerAtIndex(index)
            pageViewController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        }
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController {
        let contentVC = UIViewController()
        let imageView = UIImageView(frame: contentVC.view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: URL(string: images[index].thumbMain), completed: nil)
        contentVC.view.addSubview(imageView)
        return contentVC
    }
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = images.firstIndex(where: { $0.thumbMain == (viewController.view.subviews.first as? UIImageView)?.sd_imageURL?.absoluteString }),
              currentIndex > 0 else {
            return nil
        }
        return viewControllerAtIndex(currentIndex - 1)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = images.firstIndex(where: { $0.thumbMain == (viewController.view.subviews.first as? UIImageView)?.sd_imageURL?.absoluteString }),
              currentIndex < images.count - 1 else {
            return nil
        }
        return viewControllerAtIndex(currentIndex + 1)
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = images.firstIndex(where: { $0.thumbMain == (currentVC.view.subviews.first as? UIImageView)?.sd_imageURL?.absoluteString }) {
            pageControl.currentPage = currentIndex
        }
    }
}
