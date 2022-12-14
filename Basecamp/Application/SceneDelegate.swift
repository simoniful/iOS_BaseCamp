//
//  SceneDelegate.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var coordinator: AppCoordinator?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let nav = UINavigationController()
    coordinator = AppCoordinator(nav)
    coordinator?.start()
    window?.backgroundColor = .systemBackground
    window?.rootViewController = nav
    window?.makeKeyAndVisible()
  }
}

