//
//  FilterViewController.swift
//  InStore
//
//  Created by mac on 5/29/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

protocol ShowTabBarProtocol {
    func showTabBar()
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var pricesRangeCollectionView: UICollectionView!
    @IBOutlet weak var filterCollectionVieww: UICollectionView!
    var showTabBarProtocol: ShowTabBarProtocol?
    var filterCollectionViewLastIndexActive:IndexPath = [1 ,0]
    var pricesRangeCollectionViewLastIndexActive:IndexPath = [1 ,0]
    
    
    
    lazy var blurredView: UIView = {
        let containerView = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
        customBlurEffectView.frame = self.view.bounds
        let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        dimmedView.frame = self.view.bounds
        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func setupView() {
        
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
        
        filterCollectionVieww.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "PriceCollectionViewCell")
        filterCollectionVieww.delegate = self
        filterCollectionVieww.dataSource = self
        
        pricesRangeCollectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "PriceCollectionViewCell")
        pricesRangeCollectionView.delegate = self
        pricesRangeCollectionView.dataSource = self
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        showTabBarProtocol?.showTabBar()
        dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case filterCollectionVieww:
            return 2
        case pricesRangeCollectionView:
            return 5
        default:
            return 2
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCollectionViewCell", for: indexPath) as! FilterCell
        switch collectionView {
        case filterCollectionVieww:
            cell.name.text = Constants.sortArr[indexPath.row]
        case pricesRangeCollectionView:
            cell.name.text = Constants.rangesArr[indexPath.row]
        default:
            cell.name.text = "Error"
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case filterCollectionVieww:
            if self.filterCollectionViewLastIndexActive != indexPath {
                let cell = filterCollectionVieww.cellForItem(at: indexPath) as! FilterCell
                cell.name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.viewCell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.viewCell.layer.masksToBounds = true
                
                let cell1 = filterCollectionVieww.cellForItem(at: self.filterCollectionViewLastIndexActive) as? FilterCell
                cell1?.name.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell1?.viewCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell1?.viewCell.layer.masksToBounds = true
                self.filterCollectionViewLastIndexActive = indexPath
            }
        case pricesRangeCollectionView:
            if self.pricesRangeCollectionViewLastIndexActive != indexPath {
                let cell = pricesRangeCollectionView.cellForItem(at: indexPath) as! FilterCell
                cell.name.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.viewCell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.viewCell.layer.masksToBounds = true
                
                let cell1 = pricesRangeCollectionView.cellForItem(at: self.pricesRangeCollectionViewLastIndexActive) as? FilterCell
                cell1?.name.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell1?.viewCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell1?.viewCell.layer.masksToBounds = true
                self.pricesRangeCollectionViewLastIndexActive = indexPath
            }
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
    }
    
}




