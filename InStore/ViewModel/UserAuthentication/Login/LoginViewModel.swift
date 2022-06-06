//
//  LoginViewModel.swift
//  InStore
//
//  Created by mac on 6/3/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel: LoginViewModelProtocol {
    
    private let bag = DisposeBag()
    private var repository: RepositoryProtocol?
    
    var successfullLoginObservable: Observable<LoginResponse?>
    private var successfullLoginSubject: PublishSubject<LoginResponse?> = PublishSubject()
    private var successfullLogin: LoginResponse?{
        didSet{
            successfullLoginSubject.onNext(successfullLogin)
        }
    }
    
    var errorMessageObservable: Observable<String?>
    private var errorMessageSubject: PublishSubject<String?> = PublishSubject()
    private var errorMessage: String?{
        didSet{
            errorMessageSubject.onNext(errorMessage)
        }
    }
    
    init(repository: RepositoryProtocol?) {
        self.repository = repository
        self.errorMessageObservable = errorMessageSubject.asObservable()
        self.successfullLoginObservable = successfullLoginSubject.asObservable()
    }
    
    func login(email: String, password: String) {
        repository?.login(email: email)?
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (loginResponse) in
                if loginResponse.customers.count == 0 {
                    self?.errorMessage = "Wrong email or password"
                    return
                }
                if let safePassword = loginResponse.customers[0].tags {
                    if safePassword == password {
                        self?.successfullLogin = loginResponse
                        let currentUser = loginResponse.customers[0]
                        self?.initUserDefaults(loggedIn: true, email: currentUser.email!, username: currentUser.first_name!, id: currentUser.id!, hasAddress: !(currentUser.addresses!.isEmpty))
                        
                    }else {
                        self?.errorMessage = "Wrong email or password"
                        
                    }
                }
            }, onError: { [weak self] (error) in
                self?.errorMessage = "Please Check Your Connection!"
            }).disposed(by: bag)
    }
    private func initUserDefaults(loggedIn:Bool,email:String,username:String,id:Int,hasAddress:Bool){
        MyUserDefaults.add(val: loggedIn, key: .loggedIn)
        MyUserDefaults.add(val: email, key: .email)
        MyUserDefaults.add(val: username, key: .username)
        MyUserDefaults.add(val: id, key: .id)
        MyUserDefaults.add(val: hasAddress, key: .hasAddress)
    }
    
}
