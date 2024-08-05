//
//  UIAlert.swift
//  AwesomeChat
//
//  Created by Linh Vu on 2/8/24.
//

import Foundation
import UIKit

// - MAKR: Create AlertManager ???

extension UIViewController {
    func showAlert(title: String?, message: String, buttonTitle: String, handler: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle,
                                      style: .default,
                                      handler: { _ in
            handler()
        }))
        present(alert, animated: true)
    }
}
