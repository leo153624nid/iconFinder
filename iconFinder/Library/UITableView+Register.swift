//
//  UITableView+Register.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func register(_ types: [UITableView.Type]) {
        for type in types {
            register(type, forCellReuseIdentifier: String(describing: type.self))
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find UITableView for \(String(describing: T.self))")
        }
        return cell
    }

}
