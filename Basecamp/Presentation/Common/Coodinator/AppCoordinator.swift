//
//  AppCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
  weak var finishDelegate: CoordinatorFinishDelegate?
  var navigationController: UINavigationController
  var childCoordinators = [Coordinator]()
  var type: CoordinatorStyleCase = .app
  
  required init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    navigationController.setNavigationBarHidden(true, animated: false)
  }
  
  func start() {
    // TODO: 조건에 한하여 플로우 변경
    connectTabBarFlow()
  }
  
  internal func connectTabBarFlow() {
    let tabBarCoordinator = TabBarCoordinator(self.navigationController)
    self.store(coordinator: tabBarCoordinator)
    tabBarCoordinator.finishDelegate = self
    tabBarCoordinator.start()
    tabBarCoordinator.isCompleted = { [weak self] in
      self?.free(coordinator: tabBarCoordinator)
    }
  }
  
  internal func connectAuthFlow() {}
}

extension AppCoordinator: CoordinatorFinishDelegate {
  func didFinish(childCoordinator: Coordinator) {
    childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    navigationController.viewControllers.removeAll()
    switch childCoordinator.type {
    case .tab:
      connectTabBarFlow()
    case .auth:
      connectAuthFlow()
    default:
      break
    }
  }
}
