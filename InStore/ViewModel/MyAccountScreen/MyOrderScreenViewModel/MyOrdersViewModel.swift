//
//  MyOrdersViewModel.swift
//  InStore
//
//  Created by Mohamed Ahmed on 31/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift


protocol MyOrdersViewModelType{
    func getData()
    var orderObservable: Observable<[MockOrder]> {get set}
    var orderList : [MockOrder]{get}
}


class MyOrdersViewModel: MyOrdersViewModelType{
    
    private(set) var orderList : [MockOrder] = [MockOrder]()
    var orderObservable: Observable<[MockOrder]>
    private let orderSubject : BehaviorSubject = BehaviorSubject<[MockOrder]>.init(value: [])
    private var orders:[MockOrder] = []{
        didSet{
            self.orderList = orders
            orderSubject.onNext(orders)
        }
    }
    
    init(){
        orderObservable = orderSubject.asObservable()
    }

    
    func getData() {
        //async call or
    
         self.orders = [MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150"),MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150"),MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "bata shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150")]
    

    }
    
    
}
