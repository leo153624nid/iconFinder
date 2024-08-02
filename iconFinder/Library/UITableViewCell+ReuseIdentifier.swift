//
//  UITableViewCell+ReuseIdentifier.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }
    
}
