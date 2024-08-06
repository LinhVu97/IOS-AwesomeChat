//
//  UIAlert.swift
//  AwesomeChat
//
//  Created by Linh Vu on 2/8/24.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    func baseAlert(vc: UIViewController, title: String?, message: String, buttonTitle: String, completion: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle,
                                      style: .default,
                                      handler: { _ in
            completion()
        }))
        vc.present(alert, animated: true)
    }
}

extension AlertManager {
    // - MARK: Login Alert
    func loginSuccess(vc: SignInViewController) {
        self.baseAlert(vc: vc, title: nil, message: "Login Suceessfully !!!", buttonTitle: "OK") {
            let homeViewController = HomeViewController()
            vc.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    func loginFailure(vc: SignInViewController) {
        self.baseAlert(vc: vc, title: nil, message: "Email or password is invalid", buttonTitle: "OK") {
            vc.emailTextField.text = ""
            vc.passwordTextField.text = ""
            
            vc.textFieldDidChange(vc.emailTextField ?? UITextField())
        }
    }
    
    // - MARK: Register Alert
    func registerSuccess(vc: SignUpViewController) {
        self.baseAlert(vc: vc, title: "Success", message: "User registered successfully", buttonTitle: "OK") {
            vc.navigationController?.popViewController(animated: true)
        }
    }
    
    func registerFailure(vc: SignUpViewController) {
        self.baseAlert(vc: vc, title: nil, message: "The email address is already in use by another account !!!", buttonTitle: "OK") {
            vc.userNameTextField.text = ""
            vc.emailTextField.text = ""
            vc.passwordTextField.text = ""
            vc.checkboxButton.setupCheckBox(isChecked: false)
            
            vc.textFieldDidChange(vc.emailTextField ?? UITextField())
        }
    }
}
