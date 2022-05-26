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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
