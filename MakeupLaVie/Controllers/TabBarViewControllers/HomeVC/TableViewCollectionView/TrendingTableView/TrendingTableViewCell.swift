//
//  TrendingTableViewCell.swift
//  MakeupLaVie
//
//  Created by StarsDev on 11/05/2023.
//

import UIKit

class TrendingTableViewCell: UITableViewCell {
    
    private var viewModel = HomeViewModel()
    var responseIds: [Int] = []
    var selectedIDResponse: Int?
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CollectionViewCellDelegate2?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        configuration()
        self.collectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
}
extension TrendingTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalItems = 0
            
            for product in viewModel.products {
                totalItems += product.body.response.count
            }
            
            return totalItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as! TrendingCollectionViewCell
        var currentIndex = 0

            for product in viewModel.products {
                let responseCount = product.body.response.count

                if indexPath.item >= currentIndex && indexPath.item < currentIndex + responseCount {
                    let itemIndex = indexPath.item - currentIndex
                    let specialOffer = product.body.response[itemIndex]
                    cell.myLabel.text = product.body.response[itemIndex].title
                    cell.imglblTrending.setImage(with: product.body.response[itemIndex].image)
                    let responseId = specialOffer.id
                            responseIds.append(responseId)
                  
                    break
                }
                currentIndex += responseCount
            }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = responseIds[indexPath.row]
            selectedIDResponse = selectedID
            
            delegate?.didSelectItemAtIndex2(index: indexPath.row ,selectedID: selectedID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 130)
    }
    }


extension TrendingTableViewCell {
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
