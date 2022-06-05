//
//  SplashScreenViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 25/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var animationVC: UIView!
    
    @IBOutlet weak var logo: UIImageView!
    private var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSplashAnimation()
        

    }
    
    private func playSplashAnimation(){
        
        UIView.animate(withDuration: 3) {
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
