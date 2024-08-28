//
//  UITextFieldExtensions.swift
//  AwesomeChat
//
//  Created by Linh Vu on 31/7/24.
//

import Foundation
import UIKit

extension UITextField {
    func setupRightSideImage(imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 16, height: 16))
        imageView.image = UIImage(named: imageName)
        let imageViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageViewContainer.addSubview(imageView)
        rightView = imageViewContainer
        rightViewMode = .always
    }
    
    func setupLeftSideImage(imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 16, height: 16))
        imageView.image = UIImage(named: imageName)
        let imageViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageViewContainer.addSubview(imageView)
        leftView = imageViewContainer
        leftViewMode = .always
    }
}
