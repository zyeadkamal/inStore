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
    
    init(repository: RepositoryProtocol? = Repository.shared(localDataSource: LocalDataSource(),apiClient: ApiClient())) {
        self.repository = repository
        self.errorMessageObservable = errorMessageSubject.asObservable()
        self.successfullLoginObservable = successfullLoginSubject.asObservable()
    }
    
    func login(email: String, password: String) {
        repository?.login(email: email)?.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { (loginResponse) in
            print(loginResponse)
            if loginResponse.customers.count == 0 {
                self.errorMessage = "Wrong email or password"
                return
            }
            if let safePassword = loginResponse.customers[0].tags {
                if safePassword == password {
                    self.successfullLogin = loginResponse

                }else {
                    self.errorMessage = "Wrong email or password"

                }
            }
        }, onError: { (error) in
            self.errorMessage = "Wrong password"
            }).disposed(by: bag)
     }
    
}
