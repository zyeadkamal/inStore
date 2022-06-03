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
    
    init(repository: RepositoryProtocol? = Repository.shared(localDataSource: LocalDataSource(),apiClient: ApiClient())) {
        self.repository = repository
        self.successfullRegisterObservable = successfullRegisterSubject.asObservable()
        self.errorMessageObservable = errorMessageSubject.asObservable()
    }
    
    
    func registerNewUser(customer: NewCustomer) {
        repository?.register(customer: customer)?
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance)
            .subscribe(onNext: { (newCustomer) in
                self.successfullRegister = newCustomer
            }, onError: { (error) in
                self.errorMessage = "This email is already exist"
            }).disposed(by: bag)
    }
    
    
    
}
