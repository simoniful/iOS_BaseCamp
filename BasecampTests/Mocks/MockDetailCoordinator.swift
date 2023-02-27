//
//  MockDetailCoordinator.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/24.
//

import UIKit
@testable import Basecamp

final class StubDetailCoordinator: DetailCoordinatorProtocol {
  var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators: [Coordinator] = []
  var type: CoordinatorStyleCase = .detail
  var navigationController: UINavigationController
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {}
  
  var showDateSelectModalCalled = false
  func showDateSelectModal(with campsite: Basecamp.Campsite) {
    showDateSelectModalCalled = true
  }
  
  var navigateToFlowPhotoCalled = false
  func navigateToFlowPhoto(viewModel: Basecamp.DetailReviewMakerViewModel) {
    navigateToFlowPhotoCalled = true
  }
  
  var navigateToFlowRateCalled = false
  func navigateToFlowRate(viewModel: Basecamp.DetailReviewMakerViewModel) {
    navigateToFlowRateCalled = true
  }
  
  var navigateToFlowWebCalled = false
  func navigateToFlowWeb(with data: Basecamp.SocialMediaInfo) {
    navigateToFlowWebCalled = true
  }
  
  var navigateToFlowZoomCalled = false
  func navigateToFlowZoom(with data: String) {
    navigateToFlowZoomCalled = true
  }
  
  var navigateToFlowDetailCalled = false
  func navigateToFlowDetail(with data: Basecamp.DetailStyle) {
    navigateToFlowDetailCalled = true
  }
}
