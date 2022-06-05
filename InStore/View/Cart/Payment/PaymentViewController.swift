//
//  PaymentViewController.swift
//  InStore
//
//  Created by sandra on 5/27/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    var paymentVM : PaymentViewModelType?
    var disposeBag = DisposeBag()
    
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        print("oreder in payment --> \(paymentVM?.myOrder)")
        configureLabelsInfo()
    }
    
    init?(coder: NSCoder, paymentVM : PaymentViewModelType) {
        self.paymentVM = paymentVM
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been initialized")
    }
    
    //MARK: -- IBActions
    @IBAction func didPressCODBtn(_ sender: UIButton) {
        paymentVM?.myOrder?.order?.financialStatus = "paid"
        setOptionSelection(selectedBtn: sender, true)
        setOptionSelection(selectedBtn: applePayBtn, false)
    }
    
    
    @IBAction func didPressApplePayBtn(_ sender: UIButton) {
        paymentVM?.myOrder?.order?.financialStatus = "paid"
        setOptionSelection(selectedBtn: sender, true)
        setOptionSelection(selectedBtn: CODBtn, false)
    }
    
    
    @IBAction func didPressApplyCode(_ sender: UIButton) {
        print("code is --> \(promoCodeTF.text ?? "")")
        paymentVM?.checkCouponExistance(coupon: promoCodeTF.text ?? "", priceRoleID: "1185721155819")
        self.isCouponExists()
        
    }
    
    @IBAction func didPressPayNowBtn(_ sender: Any) {
        paymentVM?.myOrder?.order?.customer?.id = 6246222299371
        let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to Confirm the order?", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            self.paymentVM?.postOrder(order: self.paymentVM?.myOrder ?? PostOrderRequest())?.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { (postOrder) in
                print("oreder \(postOrder.order) posted")
                let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ConfirmOrderViewController.self)) as! ConfirmOrderViewController
                self.navigationController?.pushViewController(confirmationVC, animated: true)
            }).disposed(by: self.disposeBag)
        }))
        
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    //MARK: -- Functions
    func configureLabelsInfo(){
        let order = paymentVM?.myOrder?.order
        paymentAddressLbl.text = "\(order?.default_address?.city ?? "")"
        discountLbl.text = "\(order?.total_discounts ?? "") EGP"
        deliveryLbl.text = "5.0 EGP"
        totalPaymentLbl.text = order?.total_line_items_price
    }
    
    func setOptionSelection(selectedBtn :UIButton ,_ isSelected : Bool){
        if isSelected{
            selectedBtn.isSelected = true
        }else{
            selectedBtn.isSelected = false
        }
    }
    
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func isCouponExists(){
        
        guard let isExist = paymentVM?.isExists else { return }
        if isExist {
            paymentVM?.myOrder?.order?.discountCode?[0].code = promoCodeTF.text ?? ""
            print(paymentVM?.myOrder?.order?.discountCode?[0].code ?? "")
            let couponExistsAlert = UIAlertController(title: "Coupon Submitted", message: "Congratulations, coupon applied successfully 🎉", preferredStyle: .alert)
            couponExistsAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(couponExistsAlert, animated: true, completion: nil)
        }else{
            let notValidAlert = UIAlertController(title: "Not valid Coupon", message: "Unfortunately, there is no Coupon exists", preferredStyle: .alert)
                notValidAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(notValidAlert, animated: true, completion: nil)
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




//            self.paymentVM?.postOrder(order: PostOrderRequest(order: PostNewOrder(lineItems: [PostLineItem(variantID: 42851023388907, quantity: 2)], customer: MyCustomer(id: 6246222299371), financialStatus: "paid", discountCode: [Code(code: "ZEYADSAMIAGAMAL")])))?.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { (postOrder) in
//                print("oreder \(postOrder.order) posted")
//                let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ConfirmOrderViewController.self)) as! ConfirmOrderViewController
//                self.navigationController?.pushViewController(confirmationVC, animated: true)
//            }).disposed(by: self.disposeBag)
