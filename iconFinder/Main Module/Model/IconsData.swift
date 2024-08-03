//
//  IconsData.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation

// MARK: - IconsData
struct IconsData: Codable {
    let totalCount: Int
    let icons: [IconItem]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case icons
    }
}

// MARK: - IconItem
struct IconItem: Codable {
    let iconID: Int
    let tags: [String]
    let rasterSizes: [RasterSize]

    enum CodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case tags
        case rasterSizes = "raster_sizes"
    }
}

// MARK: - RasterSize
struct RasterSize: Codable {
    let formats: [FormatElement]
    let size, sizeWidth, sizeHeight: Int

    enum CodingKeys: String, CodingKey {
        case formats, size
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
    }
}

// MARK: - FormatElement
struct FormatElement: Codable {
    let format: PurpleFormat
    let previewURL: String
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case format
        case previewURL = "preview_url"
        case downloadURL = "download_url"
    }
}

enum PurpleFormat: String, Codable {
    case png = "png"
}
