//
//  ForgotPasswordViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 6/8/24.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    var isEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        resetPasswordButton.cornerBorder()
        resetPasswordButton.enableButton(isEnabled: isEnabled)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let isValid: Bool = (emailTextField.text ?? "").isValidEmail
        
        if isValid {
            resetPasswordButton.enableButton(isEnabled: isValid)
        } else {
            resetPasswordButton.enableButton(isEnabled: isValid)
        }
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.shared.resetPasswordFailure(vc: self)
            } else {
                AlertManager.shared.resetPasswordSuccess(vc: self)
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
