//
//  IconItemConverter.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation

public struct IconItemConverter {
    func map(items: [IconItem]) -> [MainTableViewCellData] {
        items.map { item in
            var name = ""
            var iconPreview = ""
            var iconDownload = ""
            
            if let maxSize = item.rasterSizes.map({ $0.size }).max(),
               let format = item.rasterSizes.first(where: { $0.size == maxSize })?.formats.first {
                
                iconPreview = format.previewURL
                iconDownload = format.downloadURL
                name = "\(maxSize) x \(maxSize)"
            } else {
                name = "No correct dimensions"
            }
            
            var description = ""
            if item.tags.count > 10 {
                description = item.tags.prefix(10).joined(separator: ", ")
            } else {
                description = item.tags.joined(separator: ", ")
            }
            
            return MainTableViewCellData(iconPreview: iconPreview,
                                         iconDownload: iconDownload,
                                         name: name,
                                         description: description)
        }
    }
}
