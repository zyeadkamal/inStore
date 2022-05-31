//
//  ProductDetailsViewController.swift
//  InStore
//
//  Created by mac on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productPhotosCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPage = 0 {
           didSet{
               pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    private func initViews() {
        productPhotosCollectionView.delegate = self
        productPhotosCollectionView.dataSource = self
    }
    
}

extension ProductDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = productPhotosCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductPhotosCollectionViewCell", for: indexPath) as! ProductPhotosCollectionViewCell
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
    
}

extension ProductDetailsViewController : UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height: self.view.frame.size.width)
    }
}
