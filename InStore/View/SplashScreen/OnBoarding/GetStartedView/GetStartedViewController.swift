//
//  GetStartedViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 25/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    var brand : Brand?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(brand?.name)
    
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
