//
//  SceneDelegate.swift
//  iconFinder
//
//  Created by A Ch on 02.08.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, 
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        // Для прода синглтон FindIconServiceImpl не подходит, но для тестового - думаю это приемлемо.
        // Затаскивать кастомный DI не хочется, тем более, что по условию нельзя использовать сторонние решения типа Needle...
        let viewModel = MainViewModel(iconService: FindIconServiceImpl.shared)
        window?.rootViewController = MainViewController(viewModel: viewModel)
        window?.makeKeyAndVisible()
    }

}
