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
    
    var activityIndicator: UIActivityIndicatorView!
    
    var isEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupIndicator()
    }
    
    private func setupView() {
        emailTextField.setupRightSideImage(imageName: "icon-email")
        passwordTextField.setupRightSideImage(imageName: "icon-key")
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        signInButton.cornerBorder()
        signInButton.enableButton(isEnabled: isEnabled)
    }
    
    private func setupIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
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
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        
        activityIndicator.startAnimating()
        
        FirebaseAuthManager().loginUser(email: email, password: password) { [weak self] success, error in
            guard let self = self else { return }
            
            activityIndicator.stopAnimating()
            
            DispatchQueue.main.async {
                if success {
                    self.showAlert(title: nil, message: "Login Suceessfully !!!", buttonTitle: "OK") {   
                        let vc = HomeViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                } else if let error = error {
                    self.showAlert(title: nil, message: "Email or password is invalid", buttonTitle: "OK") {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        
                        self.textFieldDidChange(self.emailTextField ?? UITextField())
                    }
                }
            }
        }
    }
    
    @IBAction func forgotPasswordHandler(_ sender: Any) {
    }
    
    @IBAction func changeToRegister(_ sender: Any) {
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
