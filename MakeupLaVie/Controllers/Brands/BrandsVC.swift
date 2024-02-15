//
//  BrandsVC.swift
//  MakeupLaVie
//
//  Created by Apple on 14/02/2024.
//

import UIKit

struct Brands{
    let id: Int
    let image: String
    let title: String
}

class BrandsVC: UIViewController {
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    var brandsArr = [Brands]()
    var totalPages = -1
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBrandsAPI(page: currentPage)
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
            getBrandsAPI(page: currentPage)
        }
    }
    
    func getBrandsAPI(page: Int){
        let url = base_url + "brands?page=\(page)"
        Networking.instance.getApiCall(url: url){(response, error, statusCode) in
            if error == nil && statusCode == 200{
                if let body = response["body"].dictionary{
                    if body["totalPages"] != nil{
                        self.totalPages = body["totalPages"]?.intValue ?? 0
                    }
                    if let res = body["response"]?.array{
                        for item in res{
                            let id = item["id"].intValue
                            let title = item["title"].stringValue
                            let image = item["image"].stringValue
                            
                            let obj = Brands(id: id, image: image, title: title)
                            self.brandsArr.append(obj)
                        }
                    }
                    self.brandsCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BrandsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        brandsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCVCell", for: indexPath) as! BrandsCVCell
        cell.brandTitleLbl.text = brandsArr[indexPath.item].title
        cell.brandImg.sd_setImage(with: URL(string: brandsArr[indexPath.item].image))
        cell.layer.borderColor = UIColor(named: "black-darkgrey")?.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesNextVC") as! CategoriesNextVC
        vc.selectedID = brandsArr[indexPath.item].id
        vc.selectedName = brandsArr[indexPath.item].title
        vc.isBrand = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width/2 - 15, height: 200)
    }
}
