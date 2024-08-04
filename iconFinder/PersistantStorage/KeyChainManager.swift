//
//  KeyChainManager.swift
//  iconFinder
//
//  Created by A Ch on 04.08.2024.
//

import Foundation
import Security

public protocol KeyChainManager: AnyObject {
    func loadAPIKeys() async throws
    func saveItem(key: String, value: String) -> Bool
    func readItem(key: String) -> String?
    func updateItem(key: String, value: String) -> Bool
    func deleteItem(key: String) -> Bool
}

public final class KeyChainManagerImpl: KeyChainManager {
    // Для прода синглтоны не подходят, но для тестового - думаю это приемлемо.
    // Затаскивать кастомный DI не хочется, а по условию нельзя использовать сторонние решения типа Needle...
    static let shared = KeyChainManagerImpl()
    
    private init() {}
    
    public func loadAPIKeys() async throws {
        let request = NSBundleResourceRequest(tags: ["APIkeys"])
        try await request.beginAccessingResources()
        
        let url = Bundle.main.url(forResource: "APIkeys", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let dict = try JSONDecoder().decode([String: String].self, from: data)
        
        for (key, value) in dict {
            guard saveItem(key: key, value: value) else {
                throw KeyChainError.savigItemError
            }
        }
        request.endAccessingResources()
    }
    
    public func saveItem(key: String, value: String) -> Bool {
        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!,
        ]
        // Add item
        return SecItemAdd(attributes as CFDictionary, nil) == noErr
    }
    
    public func readItem(key: String) -> String? {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
               let valueData = existingItem[kSecValueData as String] as? Data,
               let value = String(data: valueData, encoding: .utf8)
            {
                return value
            }
        }
        return nil
    }
    
    public func updateItem(key: String, value: String) -> Bool {
        //Unused now
        return true
    }
    
    public func deleteItem(key: String) -> Bool {
        //Unused now
        return true
    }
    
}

public enum KeyChainError: Error {
    case savigItemError
    case unknown
}
