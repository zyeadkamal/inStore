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
    
    private var viewModel: ProductDetailsViewModelProtocol
    var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
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
        viewModel.addProductToCart(product: viewModel.product)
        let productName = viewModel.product.title
        Toast(text: "\(productName) added to Cart", delay:Delay.short , duration: Delay.short).show()
    }
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        if Constants.favoriteProducts.contains(viewModel.product) {
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            for i in 0..<Constants.favoriteProducts.count{
                print(Constants.favoriteProducts.count)
                if Constants.favoriteProducts[i] == viewModel.product {
                    Constants.favoriteProducts.remove(at: i)
                    break
                }
            }
            ///Remove from favourites
        }else {
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            Constants.favoriteProducts.append(viewModel.product)
            ///Add to favourites
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
        addToCartButton.setTitle("Add to cart     $\(viewModel.product.varients?[0].price ?? "150")", for: .normal)
        if Constants.favoriteProducts.contains(viewModel.product){
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
}
