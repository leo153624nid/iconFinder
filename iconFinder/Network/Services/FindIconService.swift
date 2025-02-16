//
//  FindIconService.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import Foundation

protocol FindIconService {
    func fetchIconItems(query: String, completion: @escaping (Result<IconsData, NetworkError>) -> Void)
    func downloadImage(from item: MainTableViewCellData, completion: @escaping (Data?, Error?) -> Void)
}

final class FindIconServiceImpl: FindIconService {
    // Для прода синглтон не подходит, но для тестового - думаю это приемлемо.
    // Затаскивать кастомный DI не хочется, а по условию нельзя использовать сторонние решения типа Needle...
    static let shared = FindIconServiceImpl()
    
    private let keychainManager = KeyChainManagerImpl.shared
    private var token: String?
    
    private let apiKeyName = Constants.API.apiKeyName
    private let scheme = Constants.API.scheme
    private let host = Constants.API.host
    private let searchPath = Constants.API.searchPath
    private let pageSize = 20
    
    private init() {
        guard let token = keychainManager.readItem(key: apiKeyName) else {
            Task { [weak self] in
                guard let self else { return }
                try? await self.keychainManager.loadAPIKeys()
                self.token = self.keychainManager.readItem(key: apiKeyName)
            }
            return
        }
        self.token = token
    }
    
    func fetchIconItems(query: String, completion: @escaping (Result<IconsData, NetworkError>) -> Void) {
        var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = searchPath
            components.queryItems = [
                URLQueryItem(name: SearchIconsQueryParam.query.rawValue, value: query.lowercased()),
                URLQueryItem(name: SearchIconsQueryParam.count.rawValue, value: String(pageSize))
            ]
        guard let url = components.url else {
            completion(.failure(.urlError))
            return
        }
        
        fetchDataWithCacheCheck(from: url) { data, response, error in
            if let error {
                completion(.failure(.custom(error)))
            } else if let data {
                guard let iconsData = try? JSONDecoder().decode(IconsData.self, from: data) else {
                    completion(.failure(.canNotParseData))
                    return
                }
                completion(.success(iconsData))
            } else if let response = response as? HTTPURLResponse {
                completion(.failure(.statusCode(response.statusCode)))
            } else {
                completion(.failure(.unknown))
            }
        }
    }
    
    private func fetchData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let token else {
            completion(nil, nil, NetworkError.noToken)
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue(Constants.API.Headers.accept.value,
                            forHTTPHeaderField: Constants.API.Headers.accept.rawValue)
        urlRequest.setValue(Constants.API.Headers.authorization.value + token,
                            forHTTPHeaderField: Constants.API.Headers.authorization.rawValue)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data, let response {
                // Save the response in cache
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
            }
            completion(data, response, error)
        }
        .resume()
    }
    
    private func getCachedData(for url: URL) -> Data? {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return cachedResponse.data
        }
        return nil
    }

    private func fetchDataWithCacheCheck(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let cachedData = getCachedData(for: url) {
            completion(cachedData, nil, nil)
        } else {
            fetchData(from: url, completion: completion)
        }
    }
    
    func downloadImage(from item: MainTableViewCellData, completion: @escaping (Data?, Error?) -> Void) {
        guard let token else {
            completion(nil, NetworkError.noToken)
            return
        }
        guard let url = URL(string: item.iconDownload) else {
            completion(nil, NetworkError.urlError)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(Constants.API.Headers.authorization.value + token,
                            forHTTPHeaderField: Constants.API.Headers.authorization.rawValue)
        
        URLSession.shared.downloadTask(with: urlRequest) { localUrl, response, error in
            if let error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkError.badResponse)
                return
            }
            
            guard let localUrl else {
                completion(nil, NetworkError.urlError)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        .resume()
    }
    
}
