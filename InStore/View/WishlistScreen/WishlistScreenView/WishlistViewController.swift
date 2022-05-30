//
//  WishlistViewController.swift
//  InStore
//
//  Created by sandra on 5/29/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController {

    //MARK: -- IBOutlets
    @IBOutlet weak var wishlistTableView: UITableView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var noWishlistImg: UIImageView!
    
    
    
    //MARK: -- Properties
    var wishlistItems : [String] = []
    
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        registerWishlistCell()
        configureWishlistTableView()
        registerSuggestedCollectionView()
        configureSuggestedCollectionView()
    }
    
    //MARK: -- IBActions
    
    
    //MARK: -- Functions
    func configureWishlistTableView() {
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
    }
    
    func registerWishlistCell(){
        self.wishlistTableView.register(UINib(nibName: "WishlistTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func configureSuggestedCollectionView(){
        suggestedCollectionView.delegate = self
        suggestedCollectionView.dataSource = self
    }
    
    func registerSuggestedCollectionView(){
        self.suggestedCollectionView.register(UINib(nibName: "SuggestedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }

    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WishlistViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (wishlistItems.isEmpty){
            noWishlistImg.isHidden = false
            wishlistTableView.isHidden = true
        }else{
            noWishlistImg.isHidden = true
            wishlistTableView.isHidden = false
        }
        return wishlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wishlistCell = wishlistTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WishlistTableViewCell
        wishlistCell.wishlistProductTitle.text = "Helloooo"
        wishlistCell.wishlistProductPrice.text = "$53.48"
        return wishlistCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
