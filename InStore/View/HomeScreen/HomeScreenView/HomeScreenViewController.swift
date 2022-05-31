//
//  HomeScreenViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 26/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    
    @IBOutlet weak var adBanner: UIImageView!
    
    @IBOutlet weak var BrandsCollectionView: UICollectionView!
    
    var brands :[Brand] = [
        Brand(id: 0, name: "PUMA", image: BrandImage(src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/collections/ffcaaa66e8de92f803f3440640e9f676.jpg?v=1653146617"))
        ,Brand(id: 0, name: "NIKE", image: BrandImage(src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/collections/52e93c3a86b9b62e023e5977ab218302.png?v=1653146612"))
        ,Brand(id: 0, name: "HERSCHEL", image: BrandImage(src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/collections/7e6bb0fa16ee31d6537c58e4d9d453a8.png?v=1653146622"))
        ,Brand(id: 0, name: "ADIDAS", image: BrandImage(src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1653146611"))
        ,Brand(id: 0, name: "CONVERSE", image: BrandImage(src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/collections/1651743658af793833e0a0d9cf6a9c5d.png?v=1653146613"))
        ,Brand(id: 0, name: "CONVERSE", image: BrandImage(src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/collections/1651743658af793833e0a0d9cf6a9c5d.png?v=1653146613"))
        ,Brand(id: 0, name: "CONVERSE", image: BrandImage(src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/collections/1651743658af793833e0a0d9cf6a9c5d.png?v=1653146613"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViews()
        // Do any additional setup after loading the view.
        setNavControllerTransparent()
    }
    
    private func configureCollectionViews(){
        registerCellsForCollectionView()
        setupCollectionViewDataSource()
    }
    private func setupCollectionViewDataSource(){
        BrandsCollectionView.dataSource = self
        BrandsCollectionView.delegate   = self
    }
    
    private func registerCellsForCollectionView(){
        let slideNib = UINib(nibName: String(describing: BrandsCollectionViewCell.self), bundle: nil)
        BrandsCollectionView.register(slideNib, forCellWithReuseIdentifier: String(describing: BrandsCollectionViewCell.self) )
    
    }
    
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func onWomenCategoryClick(_ sender: Any) {
        print("womenCategoryPressed")
    }
    
    @IBAction func kidsCategoryPressed(_ sender: UIButton) {
        print("kidsCategoryPressed")

    }
    
    @IBAction func menCategoryPressed(_ sender: Any) {
        print("menCategoryPressed")

    }
    @IBAction func offersCategoryPressed(_ sender: UIButton) {
        print("offersCategoryPressed")

    }
}

extension HomeScreenViewController :UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BrandsCollectionViewCell.self), for: indexPath) as! BrandsCollectionViewCell
        cell.setup(brands[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: BrandsCollectionView.frame.width, height: BrandsCollectionView.frame.height)
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self)) as! GetStartedViewController
    
        viewController.brand = brands[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    

//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: true, completion: nil)
    }
}
