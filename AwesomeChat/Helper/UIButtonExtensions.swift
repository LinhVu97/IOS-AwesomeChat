//
//  UIButtonExtensions.swift
//  AwesomeChat
//
//  Created by Linh Vu on 1/8/24.
//

import Foundation
import UIKit

extension UIButton {
    func cornerBorder() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func setupCheckBox(isChecked: Bool) {
        if isChecked {
            self.setImage(UIImage(named: "check"), for: .normal)
        } else {
            self.setImage(UIImage(named: "uncheck"), for: .normal)
        }
    }
    
    func enableButton(isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.layer.backgroundColor = isEnabled ? UIColor(named: "blueColor")?.cgColor : UIColor(named: "grayColor")?.cgColor
    }
}
