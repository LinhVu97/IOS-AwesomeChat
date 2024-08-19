//
//  UIViewControllerExtensions.swift
//  AwesomeChat
//
//  Created by Linh Vu on 19/8/24.
//

import Foundation
import UIKit

extension UIViewController {
    func addViewController(_ vc: UIViewController, _ view: UIView) {
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }
}
