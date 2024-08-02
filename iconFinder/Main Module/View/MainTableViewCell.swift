//
//  MainTableViewCell.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
   
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        // TODO: -
        return iconView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    private func initialization() {
        backgroundColor = .clear
        iconView.backgroundColor = .red

        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            descriptionLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
    
    // MARK: Configure
    func configure(with item: String) {
        // TODO: - fetch and Set image
        nameLabel.text = item
        descriptionLabel.text = item + item + item + item + item + item + item + item + item + item + item
    }
    
}
