//
//  ConfirmOrderViewController.swift
//  InStore
//
//  Created by sandra on 5/25/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Lottie

class ConfirmOrderViewController: UIViewController {
    
    //MARK: -- IBOutlet
    @IBOutlet weak var continueConfirmBtn: UIButton!
    
    
    //MARK: -- Properties
    var confirmAnimationView : AnimationView?
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureConfirmAnimation()
        
    }
    
    //MARK: -- IBActions
    @IBAction func didPressContinueConfirm(_ sender: UIButton) {
    }
    
    //MARK: -- Functions
    func configureConfirmAnimation(){
        
        
        confirmAnimationView = .init(name: "confirm_order_anim")
        confirmAnimationView?.frame = view.bounds
        confirmAnimationView?.loopMode = .loop
        view.addSubview(confirmAnimationView!)
        confirmAnimationView?.play()
        view.sendSubviewToBack(confirmAnimationView!)
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
