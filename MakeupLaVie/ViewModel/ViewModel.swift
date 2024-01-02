//
//  ViewModel.swift
//  MakeupLaVie
//
//  Created by StarsDev on 23/05/2023.
//

import Foundation

final class MianHomeViewModel {
    
    var products: [HomePageModel] = []
    var eventHandler: ((_ event: EventA) -> Void)?
    
    func fetchProduct() {
        self.eventHandler?(.loading)
        
        APIManagerIOS.shared.request(
            modelType: HomePageModel.self,  // Remove the array brackets [ ]
            type: EndPointItems.home
        ) { response in
            self.eventHandler?(.stopLoading)
            
            switch response {
            case .success(let product):
                self.products = [product]  // Remove the unnecessary square brackets [ ]
                self.eventHandler?(.dataLoaded)
                
            case .failure(let error):
                print(error)
                self.eventHandler?(.error(error))
            }
        }
    }
}

extension MianHomeViewModel {
    enum EventA {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}

//final class MianHomeViewModel {
//
//    var products: [HomePageModel] = []
//    var eventHandler: ((_ event: EventA) -> Void)?
//    func fetchProduct ()
//
//    {
//        self.eventHandler?(.loading)
//        APIManagersA.shared.fetchProduct { response in
//            self.eventHandler?(.stopLoading)
//            switch response {
//            case .success(let products):
//                self.products = [products]
//                self.eventHandler?(.dataLoaded)
//            case .failure(let error):
//                print(error)
//                self.eventHandler?(.error(error))
//            }
//        }
//    }
//}
//extension MianHomeViewModel {
//    enum EventA {
//        case loading
//        case stopLoading
//        case dataLoaded
//        case error(Error?)
//    }
//}

final class HomeViewModel {

    var products: [CategoriesModel] = []
    var eventHandler: ((_ event: Event) -> Void)?
    func fetchProduct () {
        self.eventHandler?(.loading)
        APIManagers.shared.fetchProduct { [weak self] response in
            guard let self = self else { return }
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                self.products = [products]
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error)
                self.eventHandler?(.error(error))
            }
        }
    }
}
extension HomeViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}

final class ViewProductViewModel {

    var products: [ViewProductModel] = []
    var eventHandler: ((_ event: EventViewProduct) -> Void)?
    func fetchProduct () {
        self.eventHandler?(.loading)
        APIManagersViewProduct.shared.fetchProduct { [weak self] response in
            guard let self = self else { return }
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                self.products = [products]
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error)
                self.eventHandler?(.error(error))
            }
        }
    }
}
extension ViewProductViewModel {
    enum EventViewProduct {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}

final class BrowseProductViewModel {

    var products: [BrowseProductModel] = []
    var eventHandler: ((_ event: EventBrowseProduct) -> Void)?
    func fetchProduct () {
        self.eventHandler?(.loading)
        APIManagersBrowseProduct.shared.fetchProduct { [weak self] response in
            guard let self = self else { return }
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                self.products = [products]
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error)
                self.eventHandler?(.error(error))
            }
        }
    }
}
extension BrowseProductViewModel {
    enum EventBrowseProduct {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
final class WishListViewModel {

    var products: [WishListModel] = []
    var eventHandler: ((_ event: WishListProduct) -> Void)?
    func fetchProduct () {
        self.eventHandler?(.loading)
        APIManagersWishList.shared.fetchProduct { [weak self] response in
            guard let self = self else { return }
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                self.products = [products]
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error)
                self.eventHandler?(.error(error))
            }
        }
    }
}
extension WishListViewModel {
    enum WishListProduct {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
