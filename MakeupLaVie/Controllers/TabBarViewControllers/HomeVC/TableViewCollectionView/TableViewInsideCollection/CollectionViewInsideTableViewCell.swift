//
//  CollectionViewInsideTableViewCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 27/04/2023.
//

import UIKit
import Foundation
protocol CollectionViewInsideTableViewCellDelegate: AnyObject {
    func didToggleFavoriteState(_ cell: CollectionViewInsideTableViewCell)
}

class CollectionViewInsideTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl: UILabel!
    private var viewModel = MianHomeViewModel()
    weak var delegate: CollectionViewCellDelegate?
    var responseIds: [Int] = []
    var selectedIDResponse: Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        configuration()
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func seeAllBtn(_ sender: Any) {
        print("Next VC SeeAll")
    }
    
    @objc func favBtnPressed(sender: UIButton) {
        if sender.isSelected{
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            sender.isSelected = false
        }
        else{
            
            let image = UIImage(systemName: "heart.fill")?.withTintColor(#colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1))
            sender.setImage(image, for: .normal)
            sender.isSelected = true
        }
    }
}

//extension CollectionViewInsideTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        return cell
//    }
//}
extension CollectionViewInsideTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalItems = 0
        
        for product in viewModel.products {
            totalItems += product.body.recentProducts.count
        }
        return totalItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        var currentIndex = 0
        
        for product in viewModel.products {
            let responseCount = product.body.recentProducts.count
            if indexPath.item <= responseCount{
                if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
                    let itemIndex = indexPath.item - currentIndex
                    print(indexPath)
                    let specialOffer = product.body.recentProducts[itemIndex]
                    cell.titleLbl.text = product.body.recentProducts[itemIndex].title
                    cell.rsLbl.text = product.body.recentProducts[itemIndex].price
                    //                    cell.kgLbl.text = product.body.recentProducts[itemIndex].keywords
                    cell.imgView.setImage(with: product.body.recentProducts[itemIndex].image)
                    
                    print(currentIndex)
                    print(indexPath.item)
                    print(itemIndex)
                    cell.favBtn.tag = indexPath.item
                    cell.favBtn.addTarget(self, action: #selector(favBtnPressed(sender:)), for: .touchUpInside)
                    let responseId = specialOffer.id
                    //print(responseIds)
                    responseIds.append(responseId)
                    break
                }
                
            }
            currentIndex += responseCount
            
        }
        
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        switch indexPath.row{
    //        case 0,1:
    //            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
    //                return cell
    //            }
    //        case 2,3,4,5:
    //            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
    //                        var currentIndex = 0
    //                            for product in viewModel.products {
    //                                let responseCount = product.body.newProducts.count
    //
    //                                if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
    //                                                  let itemIndex = indexPath.item - currentIndex
    //                                                  cell.titleLbl.text = product.body.newProducts[itemIndex].title
    //                                                  cell.rsLbl.text = product.body.newProducts[itemIndex].price
    //                                                  cell.kgLbl.text = product.body.newProducts[itemIndex].keywords
    //                                                  cell.imgView.setImage(with: product.body.newProducts[itemIndex].image)
    //                                                  break
    //                                }
    //                                currentIndex += responseCount
    //                            }
    //                return cell
    //            }
    //        default:
    //            break
    //        }
    //        return UICollectionViewCell()
    //    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = responseIds[indexPath.row]
        selectedIDResponse = selectedID
        
        delegate?.didSelectItemAtIndex(index: indexPath.row, selectedID: selectedID)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 450)
    }
}
extension CollectionViewInsideTableViewCell {
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
                print(error)
            }
        }
    }
}
