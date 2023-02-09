//
//  MapCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/29.
//

import UIKit
import Toast

final class MapCoordinator: Coordinator {
  weak var delegate: CoordinatorDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .map
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = MapViewController(
      viewModel: MapViewModel(
        coordinator: self,
        mapUseCase: MapUseCase(
          realmRepository: RealmRepository()
        )
      )
    )
    navigationController.isNavigationBarHidden = true
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showDetailViewController(data: DetailStyle) {
    let detailCoordinator = DetailCoordinator(self.navigationController, data: data)
    detailCoordinator.parentCoordinator = self
    detailCoordinator.isCompleted = { [weak self] in
      self?.free(coordinator: detailCoordinator)
    }
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
