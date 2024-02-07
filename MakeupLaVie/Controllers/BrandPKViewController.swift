//
//  BrandPKViewController.swift
//  TabBar
//
//  Created by Rao Ahmad on 25/07/2023.

import UIKit
import MultiSlider


class BrandPKViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var startPriceLabel: UILabel!
    @IBOutlet weak var endPriceLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var subCategoriesColView: UICollectionView!
    @IBOutlet weak var subCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarTxt: UITextField!
    
    // MARK: - Variables
    var maxValue: Int?
    var minValue: Int?
    var lowerValue = Int()
    var upperValue = Int()
    var brand_Id = 0
    var brandName = ""
    var category_Id = 0
    var categoryName = ""
    var categoryArray = [CategoryModel]()
    var subCategoryArray = [SubCategoryModel]()
    var BrandArray = [CategoryModel]()
    var colorArray = [String]()
    var sizeArray = [String]()
    var selectedIndexPaths: [IndexPath] = []
    var selectedIndexPathTwo: [IndexPath] = []
    var selectedIndexPathThree: [IndexPath] = []
    var selectedIndexPathFour: [IndexPath] = []
    var selectedIndexPathFive: [IndexPath] = []
    var previouslySelectedIndex: IndexPath?
    let colors: [UIColor] = [.red, .blue, .green, .yellow]
    var multiSlider: MultiSlider!
    //let labels = ["Electronics", "Fragrances", "Kids Shop", "Devices"]
    //let brandsLabel = ["CAROLINA HERRERA", "GARNIER", "HUGGO"]
    let productLabel = ["test1", "test2", "test3"]
    let sizeLabel = ["S", "M", "L", "XL", "XXL"]
    var body: [String:Any] = [:]
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        minValue = Int(startPriceLabel.text ?? "")
        maxValue = Int(endPriceLabel.text ?? "")
        subCategoriesColView.isHidden = true
        subCategoryHeight.constant = 0
        categoriesCollectionView.allowsSelection = true
        categoriesCollectionView.allowsMultipleSelection = false
        multiSlider = MultiSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        multiSlider.thumbCount = 2
        multiSlider.trackWidth = 3.5
        multiSlider.outerTrackColor = UIColor.gray
        multiSlider.orientation = .horizontal
        multiSlider.minimumValue = 0
        multiSlider.maximumValue = 5000
        multiSlider.value = [0, 5000]
        multiSlider.thumbTintColor = UIColor.red
        multiSlider.tintColor = UIColor.red
        multiSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        priceView.addSubview(multiSlider)
        multiSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            multiSlider.leadingAnchor.constraint(equalTo: priceView.leadingAnchor),
            multiSlider.trailingAnchor.constraint(equalTo: priceView.trailingAnchor),
            multiSlider.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 46),
            multiSlider.heightAnchor.constraint(equalToConstant: 45) ])
        updatePriceLabels(lowerValue: Int(multiSlider.value[0]), upperValue: Int(multiSlider.value[1]))
        searchFormAPI()
    }
    
    //MARK: - HelperFunction
    @objc func sliderValueChanged(_ slider: MultiSlider) {
        self.lowerValue = Int(slider.value[0])
        self.upperValue = Int(slider.value[1])
        updatePriceLabels(lowerValue: lowerValue, upperValue: upperValue)
    }
    private func updatePriceLabels(lowerValue: Int, upperValue: Int) {
        startPriceLabel.text = "\(Int(lowerValue))"
        endPriceLabel.text = "\(Int(upperValue))"
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearBtnTapped(_ sender: Any) {
        startPriceLabel.text = "\(minValue!)"
        endPriceLabel.text = "\(maxValue!)"
        multiSlider.value[0] = CGFloat(minValue!)
        multiSlider.value[1] = CGFloat(maxValue!)
        searchBarTxt.text = ""
        category_Id = 0
        brand_Id = 0
        lowerValue = 0
        upperValue = 0
            body.updateValue("", forKey: "min_price")
            body.updateValue("", forKey: "max_price")
            body.updateValue(0, forKey: "category_id")

            body.updateValue(0, forKey: "brand_id")
        
            body.updateValue("", forKey: "search")
        
        if let selectedPaths = categoriesCollectionView.indexPathsForSelectedItems{
            for indexpath in selectedPaths{
                categoriesCollectionView.deselectItem(at: indexpath, animated: true)
                let cell = categoriesCollectionView.cellForItem(at: indexpath) as! CategoriesCollectionViewCell
                cell.cellView.backgroundColor = UIColor(named: "white-gray")
                cell.categoriesCellLabel.textColor = UIColor(named: "black-white")
            }
        }
        if !selectedIndexPathThree.isEmpty{
            for indexpath in selectedIndexPathThree{
                productsCollectionView.deselectItem(at: indexpath, animated: true)
                let cell = productsCollectionView.cellForItem(at: indexpath) as! ProductCollectionViewCell
                cell.productCellView.backgroundColor = UIColor(named: "white-gray")
                cell.productCellLabel.textColor = UIColor(named: "black-white")
            }
        }
        if !selectedIndexPathTwo.isEmpty{
            for indexpath in selectedIndexPathTwo{
                brandsCollectionView.deselectItem(at: indexpath, animated: true)
                let cell = brandsCollectionView.cellForItem(at: indexpath) as! BrandsCollectionViewCell
                cell.brandsCellView.backgroundColor = UIColor(named: "white-gray")
                cell.brandsCellLabel.textColor = UIColor(named: "black-white")
            }
        }
        if !selectedIndexPathFive.isEmpty{
            for indexpath in selectedIndexPathFive{
                colorCollectionView.deselectItem(at: indexpath, animated: true)
                let cell = colorCollectionView.cellForItem(at: indexpath) as! ColorCollectionViewCell
                cell.colorCellView.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        if !selectedIndexPathFour.isEmpty{
            for indexpath in selectedIndexPathFour{
                sizeCollectionView.deselectItem(at: indexpath, animated: true)
                let cell = sizeCollectionView.cellForItem(at: indexpath) as! SizeCollectionViewCell
                cell.sizeCellView.backgroundColor = UIColor(named: "white-gray")
                cell.sizeCellLabel.textColor = UIColor(named: "black-white")
            }
        }
    }
    
    @IBAction func showBtnTapped(_ sender: Any) {
        
        if lowerValue != 0{
            body.updateValue(startPriceLabel.text ?? "", forKey: "min_price")
        }
        if upperValue != 0{
            body.updateValue(endPriceLabel.text ?? "", forKey: "max_price")
        }
        if category_Id != 0{
            body.updateValue(category_Id, forKey: "category_id")
        }
        //        if categoryName != ""{
        //            body.updateValue(categoryName, forKey: "categoryName")
        //        }
        if brand_Id != 0{
            body.updateValue(brand_Id, forKey: "brand_id")
        }
        //        if brandName != ""{
        //            body.updateValue(brandName, forKey: "brandName")
        //        }
        if searchBarTxt.text != ""{
            body.updateValue(searchBarTxt.text ?? "", forKey: "search")
        }
        let userinfo = ["userInfo": body]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Data"), object: nil, userInfo: userinfo)
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchFormAPI(){
        let url = base_url + "product/search-form"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            let body = response["body"].dictionary
            let resp = body?["response"]?.dictionary
            if let categories = resp?["categories"]?.array{
                for dic in categories{
                    if dic["title"].string == ""{
                        
                    }
                    if let subCategory = dic["categories"].array{
                        
                        for subCat in subCategory{
                            let model = SubCategoryModel.init(subCat.rawValue as! Dictionary<String, AnyObject>)
                            self.subCategoryArray.append(model)
                            self.subCategoriesColView.reloadData()
                        }
                        print(self.subCategoryArray)
                    }
                    let model = CategoryModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                    self.categoryArray.append(model)
                    self.categoriesCollectionView.reloadData()
                }
                print(self.categoryArray)
            }
            if let brands = resp?["brands"]?.array{
                for dic in brands{
                    let model = CategoryModel.init(dic.rawValue as! Dictionary<String, AnyObject>)
                    self.BrandArray.append(model)
                    self.brandsCollectionView.reloadData()
                }
            }
            if let tags = resp?["tags"]?.array{
                print(tags)
            }
            if let attributes = resp?["attributes"]?.array{
                for att in attributes{
                    if let att = att["attributesList"].array{
                        for dic in att{
                            let colorAtt = dic["color"].stringValue
                            let sizeTitle = dic["title"].stringValue
                            self.colorArray.append(colorAtt)
                            self.sizeArray.append(sizeTitle)
                            self.colorCollectionView.reloadData()
                            self.sizeCollectionView.reloadData()
                        }
                        print(self.colorArray, self.sizeArray)
                    }
                }
            }
        }
    }
   
}

// MARK: - Extension CollectionVIew
extension BrandPKViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoriesCollectionView:
            return categoryArray.count
        case subCategoriesColView:
            return subCategoryArray.count
        case brandsCollectionView:
            return BrandArray.count
        case productsCollectionView:
            return productLabel.count
        case colorCollectionView:
            return colorArray.count
        case sizeCollectionView:
            return sizeArray.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoriesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCollectionViewCell
            cell.categoriesLabel?.text = categoryArray[indexPath.item].title
//            if previouslySelectedIndex == indexPath{
//                categoriesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
//                cell.cellView.backgroundColor = UIColor.red
//                cell.categoriesCellLabel.textColor = UIColor.white
//            }
            cell.isSelected = indexPath == previouslySelectedIndex
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.gray.cgColor
            
            return cell
        case subCategoriesColView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! CategoriesCollectionViewCell
            cell.categoriesLabel?.text = subCategoryArray[indexPath.item].title
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        case brandsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTwo", for: indexPath) as! BrandsCollectionViewCell
            cell.brandsCellLabel?.text = BrandArray[indexPath.item].title
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        case productsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellThree", for: indexPath) as! ProductCollectionViewCell
            cell.productCellLabel?.text = productLabel[indexPath.item]
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        case colorCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFour", for: indexPath) as! ColorCollectionViewCell
            cell.colourButton?.backgroundColor = hexStringToUIColor(hex: colorArray[indexPath.item])
            return cell
        case sizeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFive", for: indexPath) as! SizeCollectionViewCell
            
            cell.sizeCellLabel?.text = sizeArray[indexPath.item]
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoriesCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell else {
                    return
                }

                // Toggle the selected state of the cell
                cell.isSelected = !cell.isSelected

                // Update the selected index
            previouslySelectedIndex = cell.isSelected ? indexPath : nil
            self.category_Id = categoryArray[indexPath.item].id ?? 0
            self.categoryName = categoryArray[indexPath.item].title ?? ""
                // Change the background color based on the selected state
                if cell.isSelected {
                    cell.cellView.backgroundColor = UIColor.red
                    cell.categoriesCellLabel.textColor = UIColor.white
                   
                } else {
                    // Reset the background color to its original state when deselected
                    cell.cellView.backgroundColor = UIColor(named: "white-gray")
                    cell.categoriesCellLabel.textColor = UIColor(named: "black-white")
                    
                }
        case brandsCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? BrandsCollectionViewCell {
                self.brand_Id = BrandArray[indexPath.item].id ?? 0
                self.brandName = BrandArray[indexPath.item].title ?? ""
                if selectedIndexPathTwo.contains(indexPath) {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.brandsCellView.backgroundColor = UIColor(named: "white-gray")
                    cell.brandsCellLabel.textColor = UIColor(named: "black-white")
                    if let indexToRemove = selectedIndexPathTwo.firstIndex(of: indexPath) {
                        selectedIndexPathTwo.remove(at: indexToRemove)
                    }
                } else {
                    cell.brandsCellView.backgroundColor = UIColor.red
                    cell.brandsCellLabel.textColor = UIColor.white
                    //selectedIndexPathTwo.removeAll()
                    selectedIndexPathTwo.append(indexPath)
                }
            }
        case productsCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
                if selectedIndexPathThree.contains(indexPath) {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.productCellView.backgroundColor = UIColor(named: "white-gray")
                    cell.productCellLabel.textColor = UIColor(named: "black-white")
                    if let indexToRemove = selectedIndexPathThree
                        .firstIndex(of: indexPath) {
                        selectedIndexPathThree.remove(at: indexToRemove)
                    }
                } else {
                    cell.productCellView.backgroundColor = UIColor.red
                    cell.productCellLabel.textColor = UIColor.white
                    selectedIndexPathThree.removeAll()
                    selectedIndexPathThree.append(indexPath)
                }
            }
        case colorCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                if selectedIndexPathFive.contains(indexPath) {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.colorCellView.layer.borderColor = UIColor.lightGray.cgColor
                    if let indexToRemove = selectedIndexPathFive
                        .firstIndex(of: indexPath) {
                        selectedIndexPathFive.remove(at: indexToRemove)
                    }
                } else {
                    cell.colorCellView.layer.borderColor = UIColor.red.cgColor
                    //selectedIndexPathFive.removeAll()
                    selectedIndexPathFive.append(indexPath)
                }
            }
        case sizeCollectionView:
            if let cell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell {
                if selectedIndexPathFour.contains(indexPath) {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.sizeCellView.backgroundColor = UIColor(named: "white-gray")
                    cell.sizeCellLabel.textColor = UIColor(named: "black-white")
                    if let indexToRemove = selectedIndexPathFour
                        .firstIndex(of: indexPath) {
                        selectedIndexPathFour.remove(at: indexToRemove)
                    }
                } else {
                    cell.sizeCellView.backgroundColor = UIColor.red
                    cell.sizeCellLabel.textColor = UIColor.white
                    //selectedIndexPathFour.removeAll()
                    selectedIndexPathFour.append(indexPath)
                }
            }
        default:
            break
        }
    }
}
extension BrandPKViewController{
    func hexStringToUIColor(hex: String) -> UIColor? {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHex = cleanHex.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        
        Scanner(string: cleanHex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
