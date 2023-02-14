//
//  DetailCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/01.
//

import UIKit
import Toast
import HorizonCalendar

final class DetailCoordinator: NSObject, Coordinator {
  weak var parentCoordinator: Coordinator?
  weak var finishDelegate: CoordinatorFinishDelegate?
  var data: DetailStyle?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var modalNavigationController = UINavigationController()
  var type: CoordinatorStyleCase = .detail

  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    guard let data = data else { return }
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
      viewController.title = data.facltNm
    case .touristInfo(let data):
      viewController.title = data.title!
    }
    
    if parentCoordinator is MapCoordinator {
      navigationController.isNavigationBarHidden = false
    }
    
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func navigateToFlowDetail(with data: DetailStyle) {
    let detailCoordinator = DetailCoordinator(self.navigationController)
    detailCoordinator.data = data
    detailCoordinator.parentCoordinator = self
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
  
  func showDateSelectModal(with campsite: Campsite) {
    let viewController = DetailReviewDateSelectViewController(
      viewModel: DetailReviewMakerViewModel(
        coordinator: self,
        reviewMakerUseCase: ReviewMakerUseCase(
          realmRepository: RealmRepository()
        ),
        campsite: campsite
      )
    )
    viewController.title = "방문일 선택"
    modalNavigationController.viewControllers = [viewController]
    modalNavigationController.modalPresentationStyle = .pageSheet
    modalNavigationController.view.backgroundColor = .systemBackground
    if let sheet = modalNavigationController.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.delegate = self
      sheet.prefersGrabberVisible = true
      sheet.selectedDetentIdentifier = .medium
    }
    navigationController.present(modalNavigationController, animated: true)
  }
  
  func navigateToFlowRate(viewModel: DetailReviewMakerViewModel) {
    let viewController = DetailReviewRateSelectViewController(
      viewModel: viewModel
    )
    viewController.hidesBottomBarWhenPushed = true
    viewController.view.backgroundColor = .systemBackground
    viewController.title = "평가 작성"
    modalNavigationController.pushViewController(viewController, animated: true)
  }
  
  func navigateToFlowPhoto(viewModel: DetailReviewMakerViewModel) {
    let viewController = DetailReviewPhotoSelectViewController(
      viewModel: viewModel
    )
    viewController.hidesBottomBarWhenPushed = true
    viewController.view.backgroundColor = .systemBackground
    viewController.title = "사진 선택"
    modalNavigationController.pushViewController(viewController, animated: true)
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
  
  func childDidFinish(_ child: Coordinator?) {
    for (index, coordinator) in childCoordinators.enumerated() {
      if coordinator === child {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
}

extension DetailCoordinator: UISheetPresentationControllerDelegate {}
 
extension DetailCoordinator: UINavigationControllerDelegate {
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
