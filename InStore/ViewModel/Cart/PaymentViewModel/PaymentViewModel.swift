//
//  PaymentViewModel.swift
//  InStore
//
//  Created by sandra on 6/3/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol PaymentViewModelType {
    var myOrder : PostOrderRequest? {get set}
    var isExists : Bool? {get set}
    func checkCouponExistance(coupon : String, priceRoleID: String)
    func postOrder(order : PostOrderRequest) -> Observable<PostOrderRequest>?
}


class PaymentViewModel : PaymentViewModelType{
    private var repo : RepositoryProtocol?
    var myOrder : PostOrderRequest?
    var isExists: Bool?
    
    init(repo : RepositoryProtocol, myOrder : PostOrderRequest) {
        self.repo = repo
        self.myOrder = myOrder
    }
    
    func postOrder(order: PostOrderRequest) -> Observable<PostOrderRequest>? {
        return repo?.postOrder(order: order)
    }
    
    func checkCouponExistance(coupon : String, priceRoleID: String){
        
        print("coupoun is : \(coupon) id is : \(priceRoleID)")
        repo?.getDiscountCodes(priceRuleID: priceRoleID)?.observe(on: MainScheduler.instance).subscribe(onNext: { (discountCodes) in
            print("code iiiiiiiiii \(discountCodes.discount_codes[0].code)")
            discountCodes.discount_codes.forEach { (discount) in
                print("code iiiiiiiiii \(discount.code)")
                if(discount.code == coupon.trimmingCharacters(in: .whitespacesAndNewlines)){
                    self.isExists = true
                }else{
                    self.isExists = false
                }
            }
        }).disposed(by: DisposeBag())
    }
}
