//
//  NetworkError.swift
//  iconFinder
//
//  Created by A Ch on 03.08.2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case noToken
    case badResponse
    case canNotParseData
    case statusCode(Int)
    case custom(Error)
    case unknown
}
