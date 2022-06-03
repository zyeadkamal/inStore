//
//  ViewController.swift
//  InStore
//
//  Created by mac on 5/24/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var superContentView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel: LoginViewModelProtocol = LoginViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToErrorMessage()
        bindToSuccessfullRegister()
    }
    
    
}

//MARK:- IBActions
extension LoginViewController {
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if isAllFieldsFilled() {
            if isValidEmail() {
                viewModel.login(email: emailTextField.text!, password: passwordTextField.text!)
            }else{
                showAlert(message: "Unformated email please try again")
            }
        }else {
            showAlert(message: "Please fill all requird fields")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        navigateToRegister()
    }
}

//MARK:- Navigation
extension LoginViewController {
    
    func navigateToRegister() {
        let viewController = UIStoryboard(name: "UserAuthentication", bundle: nil).instantiateViewController(withIdentifier: String(describing: RegisterViewController.self)) as! RegisterViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func navigateToHome() {
        let viewController = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

//MARK:- Data Validation
extension LoginViewController {
    
    func isAllFieldsFilled() -> Bool {
        if (emailTextField.text?.isEmpty ?? true) {
            return false
        }else if (passwordTextField.text?.isEmpty ?? true) {
            return false
        }
        return true
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailTextField.text)
    }
    
}

//MARK:- Alert
extension LoginViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Binding
extension LoginViewController {
    
    func bindToSuccessfullRegister() {
        viewModel.successfullLoginObservable.observe(on: MainScheduler.instance).subscribe(onNext: { (successfullRegister) in
            self.navigateToHome()
        }).disposed(by: bag)
    }
    
    func bindToErrorMessage() {
        viewModel.errorMessageObservable.observe(on: MainScheduler.instance).subscribe(onNext: { (errorMessage) in
            self.showAlert(message: errorMessage ?? "Server timeout")
        }).disposed(by: bag)
    }
}
