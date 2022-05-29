//
//  PaymentViewController.swift
//  InStore
//
//  Created by sandra on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    //MARK: -- IBOutlets
    
    @IBOutlet weak var CODBtn: UIButton!
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var paymentAddressLbl: UILabel!
    @IBOutlet weak var promoCodeTF: UITextField!
    @IBOutlet weak var applyCodeBtn: UIButton!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var totalPaymentLbl: UILabel!
    @IBOutlet weak var payNowBtn: UIButton!
    
    //MARK: -- Properties
    
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: -- IBActions
    @IBAction func didPressCODBtn(_ sender: UIButton) {
        setOptionSelection(selectedBtn: sender, true)
        setOptionSelection(selectedBtn: applePayBtn, false)
    }
    
    
    @IBAction func didPressApplePayBtn(_ sender: UIButton) {
        setOptionSelection(selectedBtn: sender, true)
        setOptionSelection(selectedBtn: CODBtn, false)
    }
    
    
    @IBAction func didPressApplyCode(_ sender: UIButton) {
    }
    
    @IBAction func didPressPayNowBtn(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to Confirm the order?", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ConfirmOrderViewController.self)) as! ConfirmOrderViewController
            self.navigationController?.pushViewController(confirmationVC, animated: true)
        }))
        
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    //MARK: -- Functions

    func setOptionSelection(selectedBtn :UIButton ,_ isSelected : Bool){
        if isSelected{
            selectedBtn.isSelected = true
        }else{
            selectedBtn.isSelected = false
        }
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
