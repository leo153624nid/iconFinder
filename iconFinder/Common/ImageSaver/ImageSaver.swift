//
//  ImageSaver.swift
//  iconFinder
//
//  Created by A Ch on 03.08.2024.
//

import UIKit

protocol ImageSaver: AnyObject {
    func writeToPhotoAlbum(image: UIImage, handler: @escaping (Bool, Error?) -> Void)
}

final class ImageSaverImpl: NSObject, ImageSaver {
    static let shared = ImageSaverImpl()
    
    private var completion: ((Bool, Error?) -> Void)?
    
    private override init() {}
    
    func writeToPhotoAlbum(image: UIImage, handler: @escaping (Bool, Error?) -> Void) {
        self.completion = handler
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage,
                             didFinishSavingWithError error: Error?,
                             contextInfo: UnsafeRawPointer) {
        if let error {
            self.completion?(false, error)
            return
        }
        self.completion?(true, nil)
    }
}
