//
//  GetStartedViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 25/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {
    
    //var brand : Brand?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
        
    }
    @IBAction func signMeUpButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "UserAuthentication", bundle: nil).instantiateViewController(withIdentifier: String(describing: RegisterViewController.self)) as! RegisterViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func alreadyHaveAnAcountButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "UserAuthentication", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
        
    }
    
}
