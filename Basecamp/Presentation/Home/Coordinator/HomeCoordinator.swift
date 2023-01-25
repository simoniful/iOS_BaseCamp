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
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = HomeViewController(
      viewModel: HomeViewModel(
        coordinator: self,
        homeUseCase: HomeUseCase(
          realmRepository: RealmRepository(),
          campsiteRepository: CampsiteRepository(),
          touristInfoRepository: TouristInfoRepository()
        )
      )
    )
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showDetailViewController(detailStyle: DetailStyle, name: String) {
    let vc = DetailViewController(
      viewModel: DetailViewModel(
        coordinator: self,
        detailUseCase: DetailUseCase(
          campsiteRepository: CampsiteRepository(),
          realmRepository: RealmRepository(),
          touristInfoRepository: TouristInfoRepository(),
          weatherRepository: WeatherRepository(),
          naverBlogRepository: NaverBlogRepository(),
          youtubeRepository: YoutubeRepository()
        ),
        style: detailStyle
      ),
      name: name
    )
    vc.title = name
    vc.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(vc, animated: true)
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
