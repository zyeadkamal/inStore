//
//  AddAddressViewController.swift
//  InStore
//
//  Created by sandra on 5/26/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddAddressViewController: UIViewController {

    //MARK: -- IBOutlets
    @IBOutlet weak private var countryTF: UITextField!
    @IBOutlet weak private var cityTF: UITextField!
    @IBOutlet weak private var addressTF: UITextField!
    @IBOutlet weak private var phoneTF: UITextField!
    @IBOutlet weak private var addAddressBtn: UIButton!
    
    //MARK: -- Properties
    private var addAddressVM : AddAddressViewModelType?
    var disposeBag = DisposeBag()
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        
    }
    
    init?(coder: NSCoder, addAddressVM : AddAddressViewModelType) {
        self.addAddressVM = addAddressVM
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been initialized")
    }
    
    //MARK: -- IBActions
    @IBAction func didPressAddAddress(_ sender: UIButton) {
        if isValidTF(){
            addAddressVM?.addAddressForCurrentCustomer(address: Address(customer_id: 6246222299371, address1: addressTF.text, city: cityTF.text, country: countryTF.text , phone: phoneTF.text))?.subscribe( on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { customer in
                print("on next address \(customer)")
                self.showAlert(alertTitle: "Added Successfully", alertMsg: "Address Added Succssefully", handler: { _ in
                    self.clearTextFields()
                    self.navigateToAddresses()
                })
            }, onError: { error in
                print("on error address \(error)")
                self.showAlert(alertTitle: "Error", alertMsg: "Error in adding address", handler: nil)
            }, onCompleted: {
                print("completed")
                }).disposed(by: disposeBag)
        }else{
            self.showAlert(alertTitle: "Invalid Inputs", alertMsg: "Please Enter Valid Inputs", handler: nil)
        }
    }
    
    
    //MARK: -- Functions
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func showAlert(alertTitle : String, alertMsg: String, handler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    func navigateToAddresses(){
        let addressesVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AddressesViewController.self)) as! AddressesViewController
        navigationController?.pushViewController(addressesVC, animated: true)
    }
    func isValidTF() -> Bool{
        if(countryTF.text != "" && cityTF.text != "" && addressTF.text != "" && phoneTF.text != ""){
            return true
        }
        return false
    }
    func clearTextFields(){
        countryTF.text = ""
        cityTF.text = ""
        addressTF.text = ""
        phoneTF.text = ""
    }

}
