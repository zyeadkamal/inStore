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
    private var disposeBag = DisposeBag()
    static var isToPay = false
    
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
        if NetworkMonitor.shared.isConnected{
            if isValidTF(){
                let address = Address(customer_id: self.getUserId(), address1: addressTF.text, city: cityTF.text, country: countryTF.text , phone: phoneTF.text)
                addAddressVM?.addAddressForCurrentCustomer(address: address)?.subscribe( on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] customer in
                    guard let self = self else{return}
                    print("on next address \(customer)")
                    self.showAlert(alertTitle: "Added Successfully", alertMsg: "Address Added Succssefully", handler: { _ in
                        self.clearTextFields()
                        MyUserDefaults.add(val: true, key: .hasAddress)
                        if AddAddressViewController.isToPay{
                            self.navigateToAddresses()
                        }else{
                            let myAccountSB = UIStoryboard.init(name: "MyAccountScreen", bundle: nil)
                            let myAccountVC = myAccountSB.instantiateViewController(identifier: String(describing: MyAccountViewController.self))
                            self.navigationController?.pushViewController(myAccountVC, animated: true)
                        }
                        
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
        }else{
            self.showAlert(alertTitle: "Something went wrong!", alertMsg: "Please check your internet connection!", handler: nil)
        }
    }
    
    
    //MARK: -- Functions
    
    func getUserId() -> Int {
       return (MyUserDefaults.getValue(forKey: .id) as! Int)
    }
    
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
        guard let addressesVC = storyboard?.instantiateViewController(identifier: String(describing: AddressesViewController.self), creator: { (coder) in
            AddressesViewController(coder: coder, addressesVM : ChooseAddressViewModel(repo: Repository.shared(apiClient: ApiClient())!, myOrder: self.addAddressVM?.order ?? PostOrderRequest()))
        }) else { return }
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
