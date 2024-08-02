//
//  SearchTextField.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit

final class SearchTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField(placeholder: String) {
        textColor = .white
        self.placeholder = placeholder
        placeholderColor = .gray
        borderStyle = .roundedRect
        backgroundColor = .lightGray
    }
    
}
