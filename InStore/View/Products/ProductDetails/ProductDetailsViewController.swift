//
//  ProductDetailsViewController.swift
//  InStore
//
//  Created by mac on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Cosmos
import Toaster

class ProductDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productPhotosCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var productDescreption: UITextView!
    @IBOutlet weak var productRateLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    var isAddedToCart = false
    var navBarTintColor : UIColor?
    

    
    private var viewModel: ProductDetailsViewModelProtocol
    var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViews()
        
        navBarTintColor = self.navigationController?.navigationBar.tintColor
        // Navigation Bar Text:
        self.navigationController?.navigationBar.tintColor = UIColor(named: "PrimaryColor")

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let navBarTintColor = navBarTintColor else { return  }
        self.navigationController?.navigationBar.tintColor = navBarTintColor
    }
    
    init?(coder: NSCoder, viewModel: ProductDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("Error while try to navigate to Product Details viewController")
    }
    
}
//MARK:- CollectionView Delegate & DataSource
extension ProductDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.product.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = productPhotosCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductPhotosCollectionViewCell", for: indexPath) as! ProductPhotosCollectionViewCell
        cell.productImage = viewModel.product.images[indexPath.row].src
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}

//MARK:- IBActions
extension ProductDetailsViewController {
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        
        if(Utils.isNotLoggedIn()){
            let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self))
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            let productName = viewModel.product.title
            
            if(isAddedToCart){
                self.isAddedToCart = false
                self.changeButtonUI()
                self.viewModel.deleteProductFromCart(deletedProductId: Int64(self.viewModel.product.id) , customerName: self.getUserEmail())
                for i in 0...(Constants.cartProductsList.count - 1){
                    if Constants.cartProductsList[i].productTitle == viewModel.product.title {
                        Constants.cartProductsList.remove(at: i)
                    }
                }
                
            }else{
                
                self.isAddedToCart = true
                self.changeButtonUI()
                self.viewModel.addProductToCart(product: self.viewModel.product,customerName: self.getUserEmail())
                Constants.cartProductsList.append(viewModel.transformProduct(product: viewModel.product))
        
            }
            Toast(text: "\(productName) added to Cart", delay:Delay.short , duration: Delay.short).show()
        }
        
        
    }
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        if(Utils.isNotLoggedIn()){
            let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self))
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            if Constants.favoriteProducts.contains(viewModel.product) {
                favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                for i in 0..<Constants.favoriteProducts.count{
                    print(Constants.favoriteProducts.count)
                    if Constants.favoriteProducts[i] == viewModel.product {
                        Constants.favoriteProducts.remove(at: i)
                        break
                    }
                }
                
                self.viewModel.removeProductFromFavourites(customerEmail:self.getUserEmail(), deletedProductId: Int64(viewModel.product.id))
                
            }else {
                favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                Constants.favoriteProducts.append(viewModel.product)
                
                
                self.viewModel.addToFavourite(product: viewModel.product,customerEmail: self.getUserEmail())
                
            }
        }
    }
}

//MARK:- CollectionView DelegateFlowLayout
extension ProductDetailsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height: self.view.frame.size.width)
    }
}

//MARK:- Setup Views
extension ProductDetailsViewController {
    
    private func initViews() {
        pageControl.numberOfPages = viewModel.product.images.count
        productPhotosCollectionView.delegate = self
        productPhotosCollectionView.dataSource = self
        productNameLabel.text = viewModel.product.title
        productDescreption.text = viewModel.product.description
        productCategoryLabel.text = viewModel.product.productType
        let rate = Constants.productRatings[Int.random(in: 0..<7)]
        productRateLabel.text = "\(rate)"
        ratingBar.rating = rate
        if(MyUserDefaults.getValue(forKey: .currency) as! String == "USD"){
            addToCartButton.setTitle("Add to cart     $\(viewModel.product.varients?[0].price ?? "0")", for: .normal)
        }else{
            addToCartButton.setTitle("Add to cart     \(Constants.convertPriceToEGP(priceToConv: viewModel.product.varients?[0].price ?? "0")) EGP", for: .normal)
        }
        
        if Constants.favoriteProducts.contains(viewModel.product){
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        for product in Constants.cartProductsList{
            if let productTitle = product.productTitle{
                if productTitle == viewModel.product.title{
                    isAddedToCart = true
                    changeButtonUI()
                }
            }
        }
    }
    
    func changeButtonUI(){
        if (isAddedToCart){
            addToCartButton.setTitle("Remove From Cart", for: .normal)
        }
        else {
            addToCartButton.setTitle("Add to cart     \(self.getUserCurrency())\(self.viewModel.product.varients?[0].price ?? "100")", for: .normal)
        }
        
        
    }
    
    func getUserCurrency() -> String {
        if (MyUserDefaults.getValue(forKey: .currency)) == nil{
            return "&"
        }
        return (MyUserDefaults.getValue(forKey: .currency) as! String)
    }
    
    func getUserEmail() -> String {
        if (MyUserDefaults.getValue(forKey: .email)) == nil{
            return ""
        }
        return (MyUserDefaults.getValue(forKey: .email) as! String)
    }
}
