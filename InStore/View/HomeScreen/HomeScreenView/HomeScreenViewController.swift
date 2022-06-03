//
//  HomeScreenViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 26/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift

class HomeScreenViewController: UIViewController {

    //MARK: - IBOutlet

    @IBOutlet weak var womenView: UIView!
    @IBOutlet weak var adBanner: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var offersView: UIView!
    @IBOutlet weak var menView: UIView!
    @IBOutlet weak var kidsView: UIView!
    @IBOutlet weak var BrandsCollectionView: UICollectionView!
    
    //MARK: - Properties

    private var homeScreenViewModel = HomeScreenViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)! , apiClient: ApiClient())!)
    
    private var bag = DisposeBag()
    

    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViews()
        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(adsSwitcher), userInfo: nil, repeats: true)
        homeScreenViewModel.loadData()
    }
    
    
    //MARK: - Methodes

    @objc func adsSwitcher() {
        
        adBanner.image = UIImage(named: Constants.adsArr.randomElement()!)
    
    }
    
    private func configureCollectionViews(){
        registerCellsForCollectionView()
        setupCollectionViewDataSource()
        bindHomeScreenData()

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
    
    private func bindHomeScreenData(){

        homeScreenViewModel.showLoadingObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: { state in
            //print(state)
            switch state {
            case .error:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.BrandsCollectionView.alpha = 0.0
                    self.adBanner.alpha = 0.0
                    self.activityIndicator.alpha = 0.0
                    self.kidsView.alpha = 0.0
                    self.womenView.alpha = 0.0
                    self.menView.alpha = 0.0
                    self.offersView.alpha = 0.0
                    

                })
            case .empty:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.BrandsCollectionView.alpha = 0.0
                    self.adBanner.alpha = 0.0
                    self.activityIndicator.alpha = 0.0
                    self.kidsView.alpha = 0.0
                    self.womenView.alpha = 0.0
                    self.menView.alpha = 0.0
                    self.offersView.alpha = 0.0

                })
            case .loading:
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.BrandsCollectionView.alpha = 0.0
                    self.adBanner.alpha = 0.0
                    self.kidsView.alpha = 0.0
                    self.activityIndicator.alpha = 1.0

                    self.womenView.alpha = 0.0
                    self.menView.alpha = 0.0
                    self.offersView.alpha = 0.0
                })
            case .populated:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.BrandsCollectionView.alpha = 1.0
                    self.adBanner.alpha = 1.0
                    self.activityIndicator.alpha = 0.0
                    self.kidsView.alpha = 1.0
                    self.womenView.alpha = 1.0
                    self.menView.alpha = 1.0
                    self.offersView.alpha = 1.0
                    
                })
                self.BrandsCollectionView.reloadData()
            }
           
            }).disposed(by: bag)
    }
    
    //MARK: - IBActions

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
        return homeScreenViewModel.brands?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BrandsCollectionViewCell.self), for: indexPath) as! BrandsCollectionViewCell
        cell.setup( (homeScreenViewModel.brands?[indexPath.row])!)
    
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: BrandsCollectionView.frame.width, height: BrandsCollectionView.frame.height)
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self)) as! GetStartedViewController
    
       // viewController.brand = brands[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    

//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: true, completion: nil)
    }
}
