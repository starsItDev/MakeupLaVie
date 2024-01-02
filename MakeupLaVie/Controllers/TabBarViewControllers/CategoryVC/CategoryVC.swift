//
//  CategoryVC.swift
//  MakeupLaVie
//
//  Created by StarsDev on 17/04/2023.

import UIKit

class CategoryVC: UIViewController {
    
    
    @IBOutlet weak var categoriesSimpleCV: UICollectionView!
    
    @IBOutlet var categoriesGridCV: UICollectionView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var gridViewBtn: UIButton!
    private var selectedID: Int?
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        self.gridViewBtn.addTarget(self, action: #selector(toggleCategoryViewTapped(sender:)), for: .touchUpInside)
        backBtn.isHidden = true
        self.categoriesSimpleCV.isHidden = true
    }
    
    @objc func toggleCategoryViewTapped(sender: UIButton){
        if sender.isSelected{
            sender.isSelected = false
            gridViewBtn.setImage(UIImage(systemName: "square.grid.3x2.fill"), for: .normal)
            self.categoriesSimpleCV.isHidden = true
            self.categoriesGridCV.isHidden = false
        }
        else{
            
            sender.isSelected = true
            gridViewBtn.setImage(UIImage(systemName: "rectangle.grid.1x2.fill"), for: .normal)
            self.categoriesGridCV.isHidden = true
            self.categoriesSimpleCV.isHidden = false
            
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CategoryVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalItems = 0
        
        for product in viewModel.products {
            totalItems += product.body.response.count
        }
        
        return totalItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesGridCV{
            let cell = categoriesGridCV.dequeueReusableCell(withReuseIdentifier: "CategoryCollectioncell", for: indexPath) as! CategoryCollectioncell
            var currentIndex = 0
            for product in viewModel.products {
                let responseCount = product.body.response.count
                
                if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
                    let itemIndex = indexPath.item - currentIndex
                    let specialOffer = product.body.response[itemIndex]
                    cell.categoryLbl.text = product.body.response[itemIndex].title
                    cell.categoryImg.setImage(with: product.body.response[itemIndex].image)
                    break
                }
                currentIndex += responseCount
            }
            return cell
        }
        else{
            let cell = categoriesSimpleCV.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
            var currentIndex = 0
            for product in viewModel.products {
                let responseCount = product.body.response.count
                
                if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
                    let itemIndex = indexPath.item - currentIndex
                    let specialOffer = product.body.response[itemIndex]
                    cell.categoryLbl.text = product.body.response[itemIndex].title
                    cell.categoryImg.setImage(with: product.body.response[itemIndex].image)
                    break
                }
                currentIndex += responseCount
            }
            return cell
        }
        
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        return CGSize(width: 105, height: 130)
    //    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var currentIndex = 0
        
        for product in viewModel.products {
            let responseCount = product.body.response.count
            
            if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
                let itemIndex = indexPath.item - currentIndex
                let selectedID = product.body.response[itemIndex].id
                let selectedName = product.body.response[itemIndex].title
                // Save the selectedID in a property
                self.selectedID = selectedID
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "CategoriesNextVC") as? CategoriesNextVC
                vc?.selectedID = selectedID
                vc?.selectedName = selectedName
                self.navigationController?.pushViewController(vc!, animated: true)
                return
            }
            
            currentIndex += responseCount
        }
        
        print("Selected item not found")
    }
    
}
extension CategoryVC {
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
                    self.categoriesGridCV.reloadData()
                    self.categoriesSimpleCV.reloadData()
                }
            case .error(let error):
                print(error!)
            }
        }
    }
}


