//
//  DetailCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/01.
//

import UIKit
import Toast

final class DetailCoordinator: Coordinator {

  weak var parentCoordinator: Coordinator?
  weak var delegate: CoordinatorDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .detail
  let data: DetailStyle
  var isCompleted: (() -> ())?
  
  init(_ navigationController: UINavigationController, data: DetailStyle) {
    self.navigationController = navigationController
    self.data = data
  }
  
  func start() {
    let viewModel = DetailViewModel(
      coordinator: self,
      detailUseCase: DetailUseCase(
        campsiteRepository: CampsiteRepository(),
        realmRepository: RealmRepository(),
        touristInfoRepository: TouristInfoRepository(),
        weatherRepository: WeatherRepository(),
        naverBlogRepository: NaverBlogRepository(),
        youtubeRepository: YoutubeRepository()
      ),
      style: data
    )
    
    let viewController = DetailViewController(viewModel: viewModel)
    switch data {
    case .campsite(let data):
      viewController.title = data.facltNm!
    case .touristInfo(let data):
      viewController.title = data.title!
    }
    
    viewModel.didTapBack = { [weak self] in
      self?.isCompleted?()
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
  
  func navigateToFlowWeb(with data: SocialMediaInfo) {
    let viewController = DetailWebViewController()
    viewController.data = data
    viewController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func navigateToFlowZoom(with data: String) {
    let viewController = DetailZoomViewController()
    viewController.data = data
    viewController.hidesBottomBarWhenPushed = true
    viewController.modalPresentationStyle = .fullScreen
    navigationController.present(viewController, animated: true)
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
