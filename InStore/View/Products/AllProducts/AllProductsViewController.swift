//
//  AllProductsViewController.swift
//  InStore
//
//  Created by mac on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//
import UIKit
import RxSwift

class AllProductsViewController: UIViewController {
    
    @IBOutlet weak var AllProductsCollcectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var viewModel: AllProductsViewModelProtocol = AllProductsViewModel(repository: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)!,apiClient: ApiClient()))
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        hideNavigationBarShadow()
        bindActivityIndicatorState()
        bindToProductList()
        bindToProductCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllProducts()
        print("zhraaaaat")
    }
    
}

//MARK:- CollectionView Delegate & DataSource
extension AllProductsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = AllProductsCollcectionView.dequeueReusableCell(withReuseIdentifier: "AllProducetsListCell", for: indexPath) as! AllProductsCollectionViewCell
        if let safeProduct = viewModel.allProducts?[indexPath.row] {
            cell.setUpCell(product: safeProduct)
        }
        cell.addToFavouriteClosure = {
            if (Constants.favoriteProducts.contains((self.viewModel.allProducts?[indexPath.row])!)) {
                cell.addToFavouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                for i in 0..<Constants.favoriteProducts.count{
                    if Constants.favoriteProducts[i] == self.viewModel.allProducts?[indexPath.row] {
                        Constants.favoriteProducts.remove(at: i)
                        break
                    }
                }
                ///Remove from favourites
            }else {
                cell.addToFavouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                Constants.favoriteProducts.append((self.viewModel.allProducts?[indexPath.row])!)
                ///Add to favourites
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let safeProduct = viewModel.allProducts?[indexPath.row] {
            let viewModel = ProductDetailsViewModel(product: safeProduct)
            guard let produvtDetailsVC = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController", creator: { (coder) -> ProductDetailsViewController? in
                ProductDetailsViewController(coder: coder, viewModel: viewModel)
            }) else {return}
            self.navigationController?.pushViewController(produvtDetailsVC, animated: true)
        }
        
        
    }
}

//MARK:- CollectionView DelegateFlowLayout
extension AllProductsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/2)-20 , height: self.view.frame.size.width/1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    
}

//MARK:- Setup Views
extension AllProductsViewController: ShowTabBarProtocol {
    
    private func initViews() {
        searchBar.delegate = self
        AllProductsCollcectionView.delegate = self
        AllProductsCollcectionView.dataSource = self
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func hideNavigationBarShadow() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

//MARK:- IBActions
extension AllProductsViewController {
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        
        let filterVC = storyboard?.instantiateViewController(identifier: "FilterViewController", creator: { (coder) -> FilterViewController? in
            FilterViewController(coder: coder, viewModel: self.viewModel)
        })
        filterVC?.modalPresentationStyle = .overCurrentContext
        filterVC?.modalTransitionStyle = .crossDissolve
        filterVC?.showTabBarProtocol = self
        self.tabBarController?.tabBar.isHidden = true
        if let filterVC = filterVC {
            present(filterVC, animated: true)
        }
    }
    
}

//MARK:- Binding
extension AllProductsViewController {
    
    private func bindActivityIndicatorState() {
        viewModel.showLoadingObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: { state in
            
            switch state {
            case .error:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.AllProductsCollcectionView.alpha = 0.0
                    self.noResultImageView.alpha = 1.0
                    self.activityIndicator.alpha = 0.0
                    
                })
            case .empty:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.AllProductsCollcectionView.alpha = 0.0
                    self.noResultImageView.alpha = 1.0
                    self.activityIndicator.alpha = 0.0
                    
                })
            case .loading:
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.AllProductsCollcectionView.alpha = 0.0
                    self.noResultImageView.alpha = 0.0
                })
            case .populated:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.AllProductsCollcectionView.alpha = 1.0
                    self.noResultImageView.alpha = 0.0
                    self.activityIndicator.alpha = 0.0
                    
                })
            }
        }).disposed(by: bag)
    }
    
    
    func bindToProductList() {
        viewModel.allProductsObservable
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (allProducts) in
                self?.AllProductsCollcectionView.reloadData()
            }).disposed(by: bag)
    }
    
    func bindToProductCount() {
        viewModel.productCountObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (count) in
                if count == 0 {
                    self.noResultImageView.isHidden = false
                    self.noResultImageView.alpha = 1.0

                    print("el sooraa feeen")
                }else{
                    self.noResultImageView.isHidden = true
                    self.noResultImageView.alpha = 0.0

                }
            })
    }
}

//MARK:- UISearchBar Delegate
extension AllProductsViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredProduct.removeAll()
        if searchText == "" {
            viewModel.allProducts = viewModel.cashAllProduct
        }else {
            guard let allProduct = viewModel.allProducts else { return }
            for product in allProduct {
                if product.title.lowercased().contains(searchText.lowercased()){
                    viewModel.filteredProduct.append(product)
                }
            }
            viewModel.allProducts = viewModel.filteredProduct
        }
    }
}
