//
//  HomeCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import Toast_Swift

protocol HomeCoordinatorProtocol: Coordinator {
  func changeTabByIndex(tabCase: TabBarPageCase ,message: String, area: Area?, index: Int)
  func navigateToFlowDetail(with data: DetailStyle)
}

class HomeCoordinator: NSObject, HomeCoordinatorProtocol {
  weak var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .home
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewModel = HomeViewModel(
      coordinator: self,
      homeUseCase: HomeUseCase(
        realmRepository: RealmRepository(),
        touristInfoRepository: TouristInfoRepository()
      )
    )
    let viewController = HomeViewController(viewModel: viewModel)
    navigationController.delegate = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func navigateToFlowDetail(with data: DetailStyle) {
    let detailCoordinator = DetailCoordinator(self.navigationController)
    detailCoordinator.data = data
    detailCoordinator.parentCoordinator = self
    self.store(coordinator: detailCoordinator)
    detailCoordinator.start()
  }
  
  func changeTabByIndex(tabCase: TabBarPageCase, message: String, area: Area? = nil, index: Int = 0) {
    navigationController.tabBarController?.selectedIndex = tabCase.pageOrderNumber
    navigationController.tabBarController?.view.makeToast(message, position: .bottom)
    
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
  
  func navigateToRootViewController(message: String? = nil) {
    navigationController.popToRootViewController(animated: true)
    if let message = message {
      navigationController.view.makeToast(message, position: .top)
    }
  }
  
  func childDidFinish(_ child: Coordinator?) {
    for (index, coordinator) in childCoordinators.enumerated() {
      if coordinator === child {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
}

extension HomeCoordinator: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
      return
    }
    
    if navigationController.viewControllers.contains(fromViewController) {
      return
    }
    
    if let detailViewController = fromViewController as? DetailViewController {
      childDidFinish(detailViewController.viewModel.coordinator)
    }
  }
}

