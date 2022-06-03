//
//  RegisterViewController.swift
//  InStore
//
//  Created by mac on 5/25/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var superContentView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    private lazy var viewModel: RegisterViewModelProtocol = RegisterViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToSuccessfullRegister()
        bindToErrorMessage()
    }
}

//MARK:- IBActions
extension RegisterViewController {
    
    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        if isAllFieldsFilled() {
            if isValidEmail() {
                if isPasswordMatch() {
                    viewModel.registerNewUser(customer: NewCustomer(customer: Customer(first_name: usernameTextField.text,email: emailTextField.text ,tags: passwordTextField.text, addresses: nil)))
                }else {
                    showAlert(message: "Your password don't match")
                }
            }else{
                showAlert(message: "Unformated email please try again")
            }
        }else {
            showAlert(message: "Please fill all requird fields")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        navigateToLoginScreen()
    }
}

//MARK:- Data validation
extension RegisterViewController {
    
    func isAllFieldsFilled() -> Bool {
        if (usernameTextField.text?.isEmpty ?? true) {
            return false
        }else if (emailTextField.text?.isEmpty ?? true) {
            return false
        }else if (passwordTextField.text?.isEmpty ?? true) {
            return false
        }else if (repeatPasswordTextField.text?.isEmpty ?? true) {
            return false
        }
        return true
    }
    
    func isPasswordMatch() -> Bool {
        if passwordTextField.text == repeatPasswordTextField.text {
            return true
        }
        return false
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailTextField.text)
    }
    
}

//MARK:- Navigation
extension RegisterViewController {
    
    func navigateToLoginScreen() {
        let viewController = UIStoryboard(name: "UserAuthentication", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

//MARK:- Alert
extension RegisterViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Binding
extension RegisterViewController {
    
    func bindToSuccessfullRegister() {
        viewModel.successfullRegisterObservable.observe(on: MainScheduler.instance).subscribe(onNext: { (successfullRegister) in
            self.navigateToLoginScreen()
        }).disposed(by: bag)
    }
    
    func bindToErrorMessage() {
        viewModel.errorMessageObservable.observe(on: MainScheduler.instance).subscribe(onNext: { (errorMessage) in
            self.showAlert(message: errorMessage ?? "Server timeout")
        }).disposed(by: bag)
    }
}




