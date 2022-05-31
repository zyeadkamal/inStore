//
//  AllProductsViewController.swift
//  InStore
//
//  Created by mac on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class AllProductsViewController: UIViewController {
    
    @IBOutlet weak var AllProductsCollcectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func initViews() {
        AllProductsCollcectionView.delegate = self
        AllProductsCollcectionView.dataSource = self
    }
    
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        
        let filterVC = storyboard?.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
        filterVC.modalPresentationStyle = .overCurrentContext
        filterVC.modalTransitionStyle = .crossDissolve
        filterVC.showTabBarProtocol = self
        self.tabBarController?.tabBar.isHidden = true
        present(filterVC, animated: true)
        
    }
    
    
}


extension AllProductsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = AllProductsCollcectionView.dequeueReusableCell(withReuseIdentifier: "AllProducetsListCell", for: indexPath) as! AllProductsCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let produvtDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        self.navigationController?.pushViewController(produvtDetailsVC, animated: true)
        
    }
    
    
}


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

extension AllProductsViewController: ShowTabBarProtocol {
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
}
