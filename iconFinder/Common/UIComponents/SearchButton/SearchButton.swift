//
//  SearchButton.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit

final class SearchButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
        backgroundColor = .blue
    }
    
}
