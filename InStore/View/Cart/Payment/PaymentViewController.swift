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
import PassKit

class PaymentViewController: UIViewController {
    
    //MARK: -- IBOutlets
    
    @IBOutlet weak private var CODBtn: UIButton!
    @IBOutlet weak private var applePayBtn: UIButton!
    @IBOutlet weak private var paymentAddressLbl: UILabel!
    @IBOutlet weak private var promoCodeTF: UITextField!
    @IBOutlet weak private var applyCodeBtn: UIButton!
    @IBOutlet weak private var discountLbl: UILabel!
    @IBOutlet weak private var deliveryLbl: UILabel!
    @IBOutlet weak private var totalPaymentLbl: UILabel!
    @IBOutlet weak private var payNowBtn: UIButton!

    
    
    //MARK: -- Properties
    var paymentVM : PaymentViewModelType?
    private var disposeBag = DisposeBag()
    var discountApplied = false
    var isCOD = false
    var deliveryPrice : Double = 0.0
    var discountPrice : Double = 0.0
    var orderPrice : Double = 0.0
    var totalPrice : Double = 0.0
    private var request:PKPaymentRequest!
    var paymentCompleted = false

    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        configureAddressAndPriceInfo()
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
        isCOD = true
        setOptionSelection(selectedBtn: sender, true)
        setOptionSelection(selectedBtn: applePayBtn, false)
    }
    
    
    @IBAction func didPressApplePayBtn(_ sender: UIButton) {
        paymentVM?.myOrder?.order?.financialStatus = "paid"
        setOptionSelection(selectedBtn: sender, true)
        setOptionSelection(selectedBtn: CODBtn, false)
        isCOD = false
    }
    
    
    @IBAction func didPressApplyCode(_ sender: UIButton) {
        print("code is --> \(promoCodeTF.text ?? "")")
        paymentVM?.checkCouponExistance(coupon: promoCodeTF.text ?? "")
        self.isCouponExists()
    }
    
    
    
    @IBAction func didPressPayNowBtn(_ sender: Any) {
        paymentVM?.myOrder?.order?.customer?.id = Utils.getUserId()
        let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to Confirm the order?", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self](_) in
            guard let self = self else{ return}
            if(self.isCOD ) {
                self.postOrder()
            }else{
                self.requestPayment(msg: "total", price: self.totalPrice)
            }
            self.paymentVM?.deleteAllFromCart(customerEmail: MyUserDefaults.getValue(forKey: .email) as! String)
        }))
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    
    //MARK: -- Functions
    func configureAddressAndPriceInfo(){
        let order = paymentVM?.myOrder?.order
        paymentAddressLbl.text = "\(order?.default_address?.city ?? "")"
        orderPrice = Double(order?.total_line_items_price ?? "0.0") ?? 0.0
        if isCOD{
            deliveryPrice = 0.0
        }
        if discountApplied {
            discountPrice = 10.0
            totalPrice = (orderPrice + deliveryPrice) - discountPrice
        }else{
            discountPrice = 0.0
            totalPrice = (orderPrice + deliveryPrice)
        }
        discountLbl.text = "$\(discountPrice)"
        deliveryLbl.text = "FREE"
        totalPaymentLbl.text = "$\(totalPrice)"
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
            discountApplied = true
            showAlert(alertTitle: "Coupon Submitted", alertMsg: "Congratulations, coupon applied successfully 🎉")
            configureAddressAndPriceInfo()
            
        }else{
            showAlert(alertTitle: "Not valid Coupon", alertMsg: "Unfortunately, there is no Coupon exists")
        }
    }
    
    func showAlert(alertTitle: String, alertMsg: String){
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func postOrder() {
        self.paymentVM?.postOrder(order: self.paymentVM?.myOrder ?? PostOrderRequest())?.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { (postOrder) in
            print("oreder \(postOrder.order) posted")
            let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ConfirmOrderViewController.self)) as! ConfirmOrderViewController
            self.navigationController?.pushViewController(confirmationVC, animated: true)
        }).disposed(by: self.disposeBag)
    }
    
}
extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func requestPayment(msg: String, price: Double) {
        
        request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.inStore.app"
        request.supportedNetworks = [.masterCard, .visa ]
        request.supportedCountries = ["US", "EG"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = MyUserDefaults.getValue(forKey: .currency) as! String
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: msg, amount: NSDecimalNumber(value: price))]
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
                
        if controller != nil {
            controller!.delegate = self
            present(controller!, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)

        if paymentCompleted {
           // showAlret()
            self.postOrder()
        
        }
        
    }
        
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        paymentCompleted = true
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

    }
}
