//
//  SplashScreenViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 25/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Lottie
import RxSwift

class SplashScreenViewController: UIViewController {
    
    //MARK: - @IBOutlet

    @IBOutlet weak var animationVC: UIView!
    @IBOutlet weak var logo: UIImageView!
    
    //MARK: - Properties
    
    private var animationView: AnimationView?

    private var splashScreenViewModel = SplashScreenViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)! , apiClient: ApiClient())!)
    
    private var bag = DisposeBag()
    
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MyUserDefaults.getValue(forKey: .email)
        
        splashScreenViewModel.fetchFavourites(customerEmail: "mando@ggg.com")
        bindFavouritesList()
    }
    
    //MARK: - Methods

    private func bindFavouritesList(){
        splashScreenViewModel.favouritesObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: {[weak self] favourites in
            guard let self = self else{return}
            
            self.playSplashAnimation()
            Constants.favoriteProducts = favourites
        })
    }
    private func playSplashAnimation(){
        
        UIView.animate(withDuration: 2.5) {
               self.logo.alpha = 1.0
            self.animationVC.alpha = 1.0
            
           }
        animationView = .init(name: "splash")
        animationView!.frame = animationVC.bounds
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .repeat(0)
        animationView!.animationSpeed = 1
        animationVC.addSubview(animationView!)
        animationView!.play{[weak self](finished) in
            if((self?.isFirstTime()) == nil){
                self?.navigateToOnBoarding()
            }
            else {
                self?.navigateToHome()
            }
        }
    }
    
    func isFirstTime() -> Bool  {
        return (MyUserDefaults.getValue(forKey: .isFirstTime) == nil)
    }
    
    func navigateToHome(){
        let viewController = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func navigateToOnBoarding(){
        let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: OnBoardingViewController.self))
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        MyUserDefaults.add(val: false, key: .isFirstTime)
        self.present(viewController, animated: true, completion: nil)
    }


}
