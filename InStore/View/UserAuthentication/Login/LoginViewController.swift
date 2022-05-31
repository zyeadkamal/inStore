//
//  ViewController.swift
//  InStore
//
//  Created by mac on 5/24/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var superContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "UserAuthentication", bundle: nil).instantiateViewController(withIdentifier: String(describing: RegisterViewController.self)) as! RegisterViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

