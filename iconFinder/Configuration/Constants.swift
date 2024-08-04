//
//  Constants.swift
//  iconFinder
//
//  Created by A Ch on 03.08.2024.
//

import Foundation

public struct Constants {
    
    //MARK: API
    struct API {
        static let apiKeyName = "iconFinderAPIKey"
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
    
    //MARK: UI
    struct UI {
        static let placeholderImage = "placeholderImage"
        static let testIcon = "testIcon"
    }
    
}
