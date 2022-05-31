//
//  RegisterViewController.swift
//  InStore
//
//  Created by mac on 5/25/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var superContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "UserAuthentication", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "UserAuthentication", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    

}
