//
//  Coordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func connectAuthFlow()
    func connectTabBarFlow()
}

protocol Coordinator: AnyObject {
  var finishDelegate: CoordinatorFinishDelegate? { get set }
  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinator] { get set }
  var type: CoordinatorStyleCase { get }
  
  func start()
  func finish()
}

extension Coordinator {
  func finish() {
    childCoordinators.removeAll()
    finishDelegate?.didFinish(childCoordinator: self)
  }
  
  func findCoordinator(type: CoordinatorStyleCase) -> Coordinator? {
    var stack: [Coordinator] = [self]
    
    while !stack.isEmpty {
      let currentCoordinator = stack.removeLast()
      if currentCoordinator.type == type {
        return currentCoordinator
      }
      currentCoordinator.childCoordinators.forEach({ child in
        stack.append(child)
      })
    }
    return nil
  }
  
  func store(coordinator: Coordinator) {
    childCoordinators.append(coordinator)
  }
  
  func free(coordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }
  
  func changeAnimation() {
    if let window = UIApplication.shared.windows.first {
      UIView.transition(with: window,
                        duration: 0.5,
                        options: .transitionCrossDissolve,
                        animations: nil)
    }
  }
}
