//
//  MockHomeCoordinator.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/23.
//

import UIKit
@testable import Basecamp

final class StubHomeCoordinator: HomeCoordinatorProtocol {
  var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators: [Coordinator] = []
  var type: CoordinatorStyleCase = .home
  var navigationController: UINavigationController
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {}
  
  var changeTabByIndexCalled = false
  var changedTab = 0
  func changeTabByIndex(tabCase: TabBarPageCase, message: String, area: Area?, index: Int) {
    changeTabByIndexCalled = true
    changedTab = tabCase.pageOrderNumber
  }
  
  var navigateToFlowDetailCalled = false
  func navigateToFlowDetail(with data: DetailStyle) {
    navigateToFlowDetailCalled = true
  }
}
