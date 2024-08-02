//
//  SearchButton.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit
import Combine

final class SearchButton: UIButton {
    
    private var cancellables = Set<AnyCancellable>()
    
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
        setupUpdates()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
    }
    
    private func setupUpdates() {
        publisher(for: \.isEnabled)
            .sink { [weak self] isEnabled in
                guard let self else { return }
                self.backgroundColor = isEnabled ? .blue : .darkGray
            }
            .store(in: &cancellables)
    }
    
}
