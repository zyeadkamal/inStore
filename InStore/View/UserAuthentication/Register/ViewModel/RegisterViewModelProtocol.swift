//
//  RegisterViewModelProtocol.swift
//  InStore
//
//  Created by mac on 6/2/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol RegisterViewModelProtocol {
    func registerNewUser(customer: NewCustomer)
    var successfullRegisterObservable: Observable<NewCustomer?>{get}
    var errorMessageObservable: Observable<String?>{get}
}
