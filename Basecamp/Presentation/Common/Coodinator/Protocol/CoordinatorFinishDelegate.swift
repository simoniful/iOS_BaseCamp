//
//  CoordinatorDelegate.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
  func didFinish(childCoordinator: Coordinator)
}
