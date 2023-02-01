//
//  HomeCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import Toast

final class HomeCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .home
  var isCompleted: (() -> ())?
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewModel = HomeViewModel(
      coordinator: self,
      homeUseCase: HomeUseCase(
        realmRepository: RealmRepository(),
        campsiteRepository: CampsiteRepository(),
        touristInfoRepository: TouristInfoRepository()
      )
    )
    let viewController = HomeViewController(viewModel: viewModel)
    viewModel.didSubmitAction = { [weak self] detailType in
      guard let self = self else { return }
      self.navigateToFlowDetail(with: detailType)
    }
    viewModel.didTapBack = { [weak self] in
      guard let self = self else { return }
      self.isCompleted?()
    }
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func navigateToFlowDetail(with data: DetailStyle) {
    let detailCoordinator = DetailCoordinator(self.navigationController, data: data)
    detailCoordinator.parentCoordinator = self
    detailCoordinator.isCompleted = { [weak self] in
      self?.free(coordinator: detailCoordinator)
    }
    self.store(coordinator: detailCoordinator)
    detailCoordinator.start()
  }
  
  func changeTabByIndex(tabCase: TabBarPageCase ,message: String, area: Area? = nil, index: Int = 0) {
    navigationController.tabBarController?.selectedIndex = tabCase.pageOrderNumber
    navigationController.tabBarController?.view.makeToast(message, position: .center)
    
    switch tabCase {
    case .list:
      if let area = area {
        var listViewController: ListViewController
        if let arrController = navigationController.tabBarController?.viewControllers {
          for nav in arrController {
            if nav.children.contains(where: { $0 is ListViewController }) {
              listViewController = (nav.children.first as? ListViewController)!
              listViewController.viewModel.dropdownSetSignal.accept((index, area.rawValue))
            }
          }
        }
      }
    default:
      break
    }
  }
  
  func popToRootViewController(message: String? = nil) {
    navigationController.popToRootViewController(animated: true)
    if let message = message {
      navigationController.view.makeToast(message, position: .top)
    }
  }
}
