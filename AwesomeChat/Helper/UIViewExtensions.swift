//
//  UIViewExtensions.swift
//  AwesomeChat
//
//  Created by Linh Vu on 9/8/24.
//

import Foundation
import UIKit

extension UIView {
    func loadNib<T: UIView>(_ type: T.Type) {
        let nibName = String.convertToString(T.self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else { return }
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
