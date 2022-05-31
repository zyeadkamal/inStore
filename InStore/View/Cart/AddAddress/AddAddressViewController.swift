//
//  AddAddressViewController.swift
//  InStore
//
//  Created by sandra on 5/26/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController {

    //MARK: -- IBOutlets
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addAddressBtn: UIButton!
    
    //MARK: -- Properties
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavControllerTransparent()
    }
    
    //MARK: -- IBActions
    @IBAction func didPressAddAddress(_ sender: UIButton) {
//        let viewController = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
//        viewController.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: -- Functions
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }


}
