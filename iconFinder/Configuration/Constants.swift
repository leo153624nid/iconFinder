//
//  Constants.swift
//  iconFinder
//
//  Created by A Ch on 03.08.2024.
//

import Foundation

public struct Constants {
    
    struct API {
        static let scheme = "https"
        static let host = "api.iconfinder.com"
        static let searchPath = "/v4/icons/search"
        
        struct Headers {
            static let accept = Header.accept
            static let authorization = Header.authorization
        }
        
        enum Header: String {
            case accept
            case authorization = "Authorization"
            
            var value: String {
                return switch self {
                case .accept:
                    "application/json"
                case .authorization:
                    "Bearer "
                }
            }
        }
    }
    
}

//MARK: - Критические данные так хранить нельзя, надо использовать KeyChainSwift и ему подобные persistantStorage,
// но тк нельзя использовать сторонние либы, то для тестового задания - думаю приемлемо
struct AsPersistantStore {
    static let apiKey = "yq7RoWWJ9oXeExbUGoYslOYWSfYWLSAs3xslSLExkGrlE7FijPFb8k2yfZLifXuJ"
}
