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
        
    }
    

    private func initViews() {
        AllProductsCollcectionView.delegate = self
        AllProductsCollcectionView.dataSource = self
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
    
}


extension AllProductsViewController : UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/2)-20 , height: self.view.frame.size.width/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
        
}
