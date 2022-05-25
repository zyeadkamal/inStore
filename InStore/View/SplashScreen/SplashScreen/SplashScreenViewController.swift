//
//  SplashScreenViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 25/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Async after 2 seconds")
            DispatchQueue.main.async {
                
                let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: OnBoardingViewController.self))
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                
                self.present(viewController, animated: true, completion: nil)
                
            }
        
        }
        // Do any additional setup after loading the view.
    }
    

}
