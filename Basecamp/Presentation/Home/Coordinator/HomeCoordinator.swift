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
      self?.isCompleted?()
    }
    navigationController.pushViewController(viewController, animated: true)
  }
  
//  func showDetailViewController(with data: DetailStyle) {
//    let vc = DetailViewController(
//      viewModel: DetailViewModel(
//        coordinator: self,
//        detailUseCase: DetailUseCase(
//          campsiteRepository: CampsiteRepository(),
//          realmRepository: RealmRepository(),
//          touristInfoRepository: TouristInfoRepository(),
//          weatherRepository: WeatherRepository(),
//          naverBlogRepository: NaverBlogRepository(),
//          youtubeRepository: YoutubeRepository()
//        )
//      )
//    )
//    vc.hidesBottomBarWhenPushed = true
//    navigationController.pushViewController(vc, animated: true)
//  }
  
  func navigateToFlowDetail(with data: DetailStyle) {
    let detailCoordinator = DetailCoordinator(self.navigationController, data: data)
    detailCoordinator.parentCoordinator = self
    self.store(coordinator: detailCoordinator)
    detailCoordinator.start()
  }
  
  func changeTabByIndex(tabCase: TabBarPageCase ,message: String, area: Area? = nil) {
    switch tabCase {
    case .list:
      if let area = area {
        var listViewController: ListViewController
        if let arrController = navigationController.tabBarController?.viewControllers {
          for vc in arrController {
            if vc is ListViewController {
              listViewController = vc as! ListViewController
              listViewController.viewModel.areaState.accept(area)
            }
          }
        }
      }
    default:
      break
    }
    
    navigationController.tabBarController?.selectedIndex = tabCase.pageOrderNumber
    navigationController.tabBarController?.view.makeToast(message, position: .center)
  }
  
  func popToRootViewController(message: String? = nil) {
    navigationController.popToRootViewController(animated: true)
    if let message = message {
      navigationController.view.makeToast(message, position: .top)
    }
  }
}
