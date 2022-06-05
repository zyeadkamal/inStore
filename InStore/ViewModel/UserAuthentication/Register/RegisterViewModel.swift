//
//  RegisterViewModel.swift
//  InStore
//
//  Created by mac on 6/2/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewModel: RegisterViewModelProtocol {
    
    private let bag = DisposeBag()
    private var repository: RepositoryProtocol?
    
    var successfullRegisterObservable: Observable<NewCustomer?>
    private var successfullRegisterSubject: PublishSubject<NewCustomer?> = PublishSubject()
    private var successfullRegister: NewCustomer?{
        didSet{
            successfullRegisterSubject.onNext(successfullRegister)
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
        self.successfullRegisterObservable = successfullRegisterSubject.asObservable()
        self.errorMessageObservable = errorMessageSubject.asObservable()
    }
    
    
    func registerNewUser(customer: NewCustomer) {
        repository?.register(customer: customer)?
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (newCustomer) in
                self?.successfullRegister = newCustomer
            }, onError: { [weak self] (error) in
                self?.errorMessage = "This email is already exist"
            }).disposed(by: bag)
    }
    
    
    
}
