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
    
    var isExists : Bool? {get set}
    var discountCodes : [DiscountCode] {get set}
    var myOrder : PostOrderRequest? {get set}
    func postOrder(order : PostOrderRequest) -> Observable<PostOrderRequest>?
    func checkCouponExistance(coupon : String)
}


class PaymentViewModel : PaymentViewModelType{
    
    private var repo : RepositoryProtocol?
    var myOrder : PostOrderRequest?
    var isExists: Bool?
    var discountCodes: [DiscountCode] = []
    
    private var discountCodesList : [DiscountCode] = []{
        didSet{
            self.discountCodes = discountCodesList
            print(discountCodes.count)
        }
    }
    
    init(repo : RepositoryProtocol, myOrder : PostOrderRequest) {
        self.repo = repo
        self.myOrder = myOrder
    }
    
    func postOrder(order: PostOrderRequest) -> Observable<PostOrderRequest>? {
        return repo?.postOrder(order: order)
    }
    
    //    private func getDiscountCodes() -> Observable<DiscountCodes>?{
    //        return repo?.getDiscountCodes(priceRuleID: "1027348594860")
    //    }
    
    
    
    func checkCouponExistance(coupon : String){
        var coupons = Constants.discountCodes
        for code in coupons{
            print("\(code.code) and     \(coupon)")
            if code.code.lowercased() == coupon.lowercased(){
                isExists = true
                break
            }else{
                isExists = false
            }
        }
        
    }
}

