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
  
  init(_ navigationController: UINavigationController, data: DetailStyle) {
    self.navigationController = navigationController
    self.data = data
  }
  
  func start() {
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
        style: data
      )
    )
    switch data {
    case .campsite(let data):
      vc.title = data.facltNm!
    case .touristInfo(let data):
      vc.title = data.title!
    }
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showDetailViewController(detailStyle: DetailStyle, name: String) {
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
//        ),
//        style: detailStyle
//      ),
//      name: name
//    )
//    vc.title = name
//    vc.hidesBottomBarWhenPushed = true
//    navigationController.pushViewController(vc, animated: true)
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
