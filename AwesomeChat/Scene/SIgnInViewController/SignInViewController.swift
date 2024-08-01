//
//  SignInViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 31/7/24.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var isEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        emailTextField.setupRightSideImage(imageName: "icon-email")
        passwordTextField.setupRightSideImage(imageName: "icon-key")
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        signInButton.cornerBorder()
        signInButton.enableButton(isEnabled: isEnabled)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isValid: Bool = (emailTextField.text ?? "").isValidEmail && (passwordTextField.text ?? "").isValidPassword
        
        if isValid {
            signInButton.enableButton(isEnabled: isValid)
        } else {
            signInButton.enableButton(isEnabled: isValid)
        }
    }
    
    @IBAction func loginHandler(_ sender: Any) {
    }
    
    @IBAction func forgotPasswordHandler(_ sender: Any) {
    }
    
    @IBAction func changeToRegister(_ sender: Any) {
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
