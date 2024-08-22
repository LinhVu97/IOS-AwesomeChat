//
//  UITableViewExtensions.swift
//  AwesomeChat
//
//  Created by Linh Vu on 21/8/24.
//

import Foundation
import UIKit

extension UITableView {
    func regsiterCell<T: UITableViewCell>(ofType type: T.Type) {
        let nibName = String.convertToString(T.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
}
