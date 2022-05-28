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
    }
    
    //MARK: -- IBActions
    @IBAction func didPressAddAddress(_ sender: UIButton) {
    }
    
    
    //MARK: -- Functions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
