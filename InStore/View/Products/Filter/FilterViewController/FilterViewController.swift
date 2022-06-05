//
//  FilterViewController.swift
//  InStore
//
//  Created by mac on 5/29/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import IBAnimatable

protocol ShowTabBarProtocol {
    func showTabBar()
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var clothesCheckBox: AnimatableCheckBox!
    @IBOutlet weak var shoesCheckBox: AnimatableCheckBox!
    @IBOutlet weak var accessoriesCheckBox: AnimatableCheckBox!
    @IBOutlet weak var kidsCheckBox: AnimatableCheckBox!
    @IBOutlet weak var menCheckBox: AnimatableCheckBox!
    @IBOutlet weak var womenCheckBox: AnimatableCheckBox!
    @IBOutlet weak var pricesRangeCollectionView: UICollectionView!
    @IBOutlet weak var filterCollectionVieww: UICollectionView!
    var showTabBarProtocol: ShowTabBarProtocol?
    var filterCollectionViewLastIndexActive:IndexPath = [1 ,0]
    var pricesRangeCollectionViewLastIndexActive:IndexPath = [1 ,0]
    var sort: SortMechanism?
    var priceRange: PriceRange?
    
    
    private var viewModel: AllProductsViewModelProtocol
    
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
    
    init?(coder: NSCoder, viewModel: AllProductsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error while navigate to filterViewController")
    }
    
}

//MARK:- CollectionViews Delegate and Datasource
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
            if indexPath.row == 0 {
                sort = .LowToHigh
            }else {
                sort = .HighToLow
            }
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
            switch indexPath.row {
            case 0:
                priceRange = .Under25
            case 1:
                priceRange = .From25To50
            case 2:
                priceRange = .From50To100
            case 3:
                priceRange = .From100To200
            case 4:
                priceRange = .From200AndAbove
            default:
                break
            }
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

//MARK:- Setup Views
extension FilterViewController {
    
    func setupView() {
        
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
        
        [filterCollectionVieww,pricesRangeCollectionView].forEach {
            $0?.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "PriceCollectionViewCell")
            $0?.delegate = self
            $0?.dataSource = self
        }
        
        womenCheckBox.checked = viewModel.womenCategory ?? false
        menCheckBox.checked = viewModel.menCategory ?? false
        kidsCheckBox.checked = viewModel.kidsCategory ?? false
        accessoriesCheckBox.checked = viewModel.accessoriesCategory ?? false
        clothesCheckBox.checked = viewModel.clothesCategory ?? false
        shoesCheckBox.checked = viewModel.shoesCategory ?? false
        
    }
    
}

//MARK:- IBActions
extension FilterViewController {
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        showTabBarProtocol?.showTabBar()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showResultButtonPressed(_ sender: UIButton) {
        if womenCheckBox.checked {
            viewModel.womenCategory = true
        }else{
            viewModel.womenCategory = nil
        }
        if menCheckBox.checked {
            viewModel.menCategory = true
        }else{
            viewModel.menCategory = nil
        }
        if kidsCheckBox.checked {
            viewModel.kidsCategory = true
        }else{
            viewModel.kidsCategory = nil
        }
        if accessoriesCheckBox.checked {
            viewModel.accessoriesCategory = true
        }else{
            viewModel.accessoriesCategory = nil
        }
        if shoesCheckBox.checked {
            viewModel.shoesCategory = true
        }else{
            viewModel.shoesCategory = nil
        }
        if clothesCheckBox.checked {
            viewModel.clothesCategory = true
        }else{
            viewModel.clothesCategory = nil
        }
        viewModel.priceRange = priceRange
        viewModel.sortMechanism = sort
        viewModel.getAllProducts()
        showTabBarProtocol?.showTabBar()
        dismiss(animated: true, completion: nil)
    }
    
}




