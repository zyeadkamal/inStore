//
//  WishlistViewController.swift
//  InStore
//
//  Created by sandra on 5/29/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift

class WishlistViewController: UIViewController {

    //MARK: -- IBOutlets
    @IBOutlet weak var wishlistTableView: UITableView!
    @IBOutlet weak var noWishlistImg: UIImageView!
    
    
    //MARK: -- Properties
    var wishlistItems : [String] = []
    private var wishlistViewModel = WishlistViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)! , apiClient: ApiClient())!)
    
    private var bag = DisposeBag()
    

    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        registerWishlistCell()
        configureWishlistTableView()
        bindFavourites()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wishlistViewModel.fetchFavourites(customerEmail: self.getUserEmail())
        
    }
    
    //MARK: -- IBActions
    
    
    //MARK: -- Functions
    
    func getUserEmail() -> String {
        if (MyUserDefaults.getValue(forKey: .email)) == nil{
            return ""
        }
        return (MyUserDefaults.getValue(forKey: .email) as! String)
    }

    func configureWishlistTableView() {
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
    }
    
    func registerWishlistCell(){
        self.wishlistTableView.register(UINib(nibName: "WishlistTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    

    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func bindFavourites(){
        wishlistViewModel.favouritesObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: {
            [weak self] favourites in
            self?.wishlistTableView.reloadData()
            
        })
    }

}

extension WishlistViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (wishlistViewModel.getFavouritesCount() == 0){
            noWishlistImg.isHidden = false
            wishlistTableView.isHidden = true
        }else{
            noWishlistImg.isHidden = true
            wishlistTableView.isHidden = false
        }
        return wishlistViewModel.getFavouritesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wishlistCell = wishlistTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WishlistTableViewCell
        let selectedItem = self.wishlistViewModel.getFavouriteByIndex(index: indexPath.row)

        wishlistCell.setupCell(favourite: wishlistViewModel.getFavouriteByIndex(index: indexPath.row))
        wishlistCell.isAddedToCart = self.wishlistViewModel.checkIfProductAddedToCart(customerEmail: self.getUserEmail(), productId: selectedItem.id)!
        wishlistCell.changeButtonUI()
        wishlistCell.addToCart = { [weak self] () in
            
            guard let self = self else {return}
            
            if(wishlistCell.isAddedToCart){
                print("\(selectedItem) removed")
                wishlistCell.isAddedToCart = false
                wishlistCell.changeButtonUI()
                self.wishlistViewModel.deleteProductFromCart(deletedProductId: selectedItem.id , customerName: self.getUserEmail())
            
                
            }else{
                print("\(self.wishlistViewModel.getFavouriteByIndex(index: indexPath.row)) added")
                wishlistCell.isAddedToCart = true
                wishlistCell.changeButtonUI()
                self.wishlistViewModel.addToCart(product: self.castFavouriteToProduct(favourite: selectedItem),customerName: self.getUserEmail())
            }
           
        }
    
        return wishlistCell
    }
    
    func castFavouriteToProduct(favourite:Favourites) -> Product{
        return Product(id: Int(favourite.id), title: favourite.title! , description: favourite.description, vendor: favourite.vendor, productType: favourite.productType, images: [ProductImage(id: 0, productID: Int(favourite.id), position: 0, width: 0, height: 0, src: favourite.image!, graphQlID: "")], varients: [Varient(id: 0, productID: Int(favourite.id), title: favourite.title!, price: favourite.price!)], count: 0, isFavourite: true)
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: " Remove From Favourites", message: "Are you sure you want to delete this \nchoose delete or cancel", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            
            let selectedItem = self.wishlistViewModel.getFavouriteByIndex(index: indexPath.row)
        
            
            self.wishlistTableView.beginUpdates()
            
            self.wishlistViewModel.removeProductFromFavourites(customerEmail: self.getUserEmail(), deletedProductId: selectedItem.id)
        
            
            self.wishlistViewModel.favourites.remove(at: indexPath.row)
            Constants.favoriteProducts.remove(at: indexPath.row)
            
            self.wishlistTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            self.wishlistTableView.endUpdates()
            
            
        
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Cancel is pressed")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}

extension WishlistViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let suggestedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SuggestedCollectionViewCell
        suggestedCell.suggestedProductTitle.text = "Kids Shoes"
        suggestedCell.suggestedProductPrice.text = "$65.2"
        suggestedCell.suggestedProductDesc.text = "Amet minisit aliqua dolor do amet sint."
        suggestedCell.productRatting.text = "5.0 (35)"
        return suggestedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 250, height:  200)
    }
}
