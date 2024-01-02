//
//  SpecialTableView.swift
//  MakeupLaVie
//
//  Created by StarsDev on 26/05/2023.
//

import UIKit
protocol SpecialTableViewDelegate: AnyObject {
    func didToggleFavoriteState(_ cell: SpecialCollectionCell)
}

class SpecialTableView: UITableViewCell  {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl: UILabel!
  
    private var viewModel = MianHomeViewModel()
    weak var delegate: CollectionViewCellDelegate?
    
    var responseIds: [Int] = []
    var selectedIDResponse: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configuration()
        self.collectionView.register(UINib(nibName: "SpecialCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SpecialCollectionCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension SpecialTableView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalItems = 0

            for product in viewModel.products {
                totalItems += product.body.newProducts.count
            }

            return totalItems
       // return viewModel.products.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialCollectionCell", for: indexPath) as! SpecialCollectionCell
        var currentIndex = 0

            for product in viewModel.products {
                let responseCount = product.body.specialOffers.count

                if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
                    let itemIndex = indexPath.item - currentIndex
                    let specialOffer = product.body.specialOffers[itemIndex]
                    cell.titleLbl.text = product.body.specialOffers[itemIndex].title
                    cell.rsLbl.text = product.body.specialOffers[itemIndex].price
                    cell.imgView.setImage(with: product.body.specialOffers[itemIndex].image)
                    let responseId = specialOffer.id
                            responseIds.append(responseId)
                    break
                }
                currentIndex += responseCount
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 450)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = responseIds[indexPath.row]
            selectedIDResponse = selectedID
            
            delegate?.didSelectItemAtIndex(index: indexPath.row, selectedID: selectedID)
        }
//    func didSelectItemAtIndex(index: Int, selectedID: Int) {
//        selectedIDResponse = selectedID
//            delegate?.didSelectItemAtIndex(index: index, selectedID: selectedID)
//    }
    }
extension SpecialTableView {
    func configuration() {
        initViewModel()
        observeEvent()
    }
    func initViewModel() {
        viewModel.fetchProduct()
    }
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loading:
                print("Product loading....")
            case .stopLoading:
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                print(self.viewModel.products)
                DispatchQueue.main.async {
                    self.responseIds.removeAll()
                    self.collectionView.reloadData()
                }
            case .error(let error):
                print(error)
            }
        }
    }
}
