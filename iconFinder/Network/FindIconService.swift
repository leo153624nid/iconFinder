//
//  FindIconService.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation

protocol FindIconService {
    func fetchIconItems(completion: @escaping (Result<IconsData, NetworkError>) -> Void)
}

final class FindIconServiceImpl: FindIconService {
    private let apiKey = "yq7RoWWJ9oXeExbUGoYslOYWSfYWLSAs3xslSLExkGrlE7FijPFb8k2yfZLifXuJ"
//    private let clientID = "OyoXg3LaOoZ6dY6IeqE8n0UTs5hQzgXntov6QhuJd9BpKsiSiy1PYpUr6KfGLCmS"
    private let urlString = "https://api.iconfinder.com/v4/icons/search?query=arrow&count=10" // TODO
    
    // пока что пусть будет синглтоном. Знаю что это не правильно, но затаскивать DI пока не хочу
    static var shared: FindIconServiceImpl { FindIconServiceImpl() }
    
    private init() {}
    
    func fetchIconItems(completion: @escaping (Result<IconsData, NetworkError>) -> Void) {
        // TODO
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(.unknown))
                return
            }
            if let data {
                guard let iconsData = try? JSONDecoder().decode(IconsData.self, from: data) else {
                    completion(.failure(.canNotParseData))
                    return
                }
                completion(.success(iconsData))
                return
            }
            completion(.failure(.unknown))
        }
        .resume()
    }
    
}

enum NetworkError: Error {
    case urlError
    case canNotParseData
    case unknown
}
