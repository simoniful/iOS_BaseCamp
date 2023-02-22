//
//  ListCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/25.
//

import UIKit
import Toast_Swift

final class ListCoordinator: Coordinator {
  weak var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .list
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = ListViewController(
      viewModel: ListViewModel(
        coordinator: self,
        listUseCase: ListUseCase(
          touristInfoRepository: TouristInfoRepository(),
          realmRepository: RealmRepository()
        ),
        area: nil
      )
    )
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showDetailViewController(data: DetailStyle) {
    let detailCoordinator = DetailCoordinator(self.navigationController)
    detailCoordinator.data = data
    detailCoordinator.parentCoordinator = self
//    detailCoordinator.isCompleted = { [weak self] in
//      self?.free(coordinator: detailCoordinator)
//    }
    self.store(coordinator: detailCoordinator)
    detailCoordinator.start()
  }
  
  func popToRootViewController(message: String? = nil) {
    navigationController.popToRootViewController(animated: true)
    if let message = message {
      navigationController.view.makeToast(message, position: .top)
    }
  }
}
