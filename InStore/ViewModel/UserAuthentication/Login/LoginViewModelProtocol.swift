//
//  LoginViewModelProtocol.swift
//  InStore
//
//  Created by mac on 6/3/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginViewModelProtocol {
    func login(email: String, password: String)
    var successfullLoginObservable: Observable<LoginResponse?>{get}
    var errorMessageObservable: Observable<String?>{get}
    func fetchFavourites(customerEmail: String)
}
