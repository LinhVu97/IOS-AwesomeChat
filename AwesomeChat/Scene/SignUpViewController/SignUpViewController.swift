//
//  SignUpViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 1/8/24.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var termAndConditionLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    var isEnabled = false
    
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        userNameTextField.setupRightSideImage(imageName: "icon-user")
        emailTextField.setupRightSideImage(imageName: "icon-email")
        passwordTextField.setupRightSideImage(imageName: "icon-key")
        
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        registerButton.cornerBorder()
        registerButton.enableButton(isEnabled: isEnabled)
        checkboxButton.setupCheckBox(isChecked: isChecked)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isValid: Bool = (emailTextField.text ?? "").isValidEmail &&
            (passwordTextField.text ?? "").isValidPassword &&
            (userNameTextField.text ?? "").isValidName
        
        registerButton.enableButton(isEnabled: isValid)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func checkboxHandler(_ sender: Any) {
        isChecked = !isChecked
        checkboxButton.setupCheckBox(isChecked: isChecked)
        
        if isChecked == true {
            registerButton.enableButton(isEnabled: isChecked)
        } else {
            registerButton.enableButton(isEnabled: isChecked)
        }
    }
    
    @IBAction func registerHandler(_ sender: Any) {
    }
}
