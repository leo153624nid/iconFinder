//
//  ImageLoader.swift
//  iconFinder
//
//  Created by A Ch on 03.08.2024.
//

import UIKit

final class ImageLoader: UIImageView {

    private let imageCache: ImageCacheType
    
    private var imageURL: URL?
    private let activityIndicator = UIActivityIndicatorView()
    
    init(imageCache: ImageCacheType) {
        self.imageCache = imageCache
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImageWithUrl(_ url: URL) {

        // setup activityIndicator...
        activityIndicator.color = .darkGray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url

        image = nil
        activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache[url] {

            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error {
                print(error)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }

            DispatchQueue.main.async {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    self.imageCache[url] = imageToCache

                }
                self.activityIndicator.stopAnimating()
            }
        }
        .resume()
    }
}
