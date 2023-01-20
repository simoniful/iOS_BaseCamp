//
//  SearchCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/14.
//

import Foundation
import UIKit
import Toast

final class SearchCoordinator: NSObject, Coordinator {
  weak var delegate: CoordinatorDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .search
  
  var modalNavigationController = UINavigationController()
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = SearchViewController(
      viewModel: SearchViewModel(
        coordinator: self,
        searchUseCase: SearchUseCase(
          campsiteRepository: CampsiteRepository(),
          realmRepository: RealmRepository()
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
    vc.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showFilterMainModal(_ viewModel: FilterMainViewModel) {
    let vc = FilterMainViewController(viewModel: viewModel)
    vc.title = "필터"
    modalNavigationController.viewControllers = [vc]
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
  
  func showFilterSubViewController(_ viewModel: FilterSubViewModel, type: FilterCase) {
    viewModel.type = type
    let vc = FilterSubViewController(viewModel: viewModel)
    vc.hidesBottomBarWhenPushed = true
    vc.view.backgroundColor = .systemBackground
    vc.title = type.title
    modalNavigationController.pushViewController(vc, animated: true)
  }
  
  func popToFilterMainViewController(message: String? = nil, filterCase: FilterCase) {
    let viewControllerStack = modalNavigationController.viewControllers
    for viewController in viewControllerStack {
      if let filterMainViewController = viewController as? FilterMainViewController {
        switch filterCase {
        case .area:
          filterMainViewController.viewModel.areaFilterState.accept(filterCase)
        case .environment:
          filterMainViewController.viewModel.environmentFilerState.accept(filterCase)
        case .rule:
          filterMainViewController.viewModel.ruleFilterState.accept(filterCase)
        case .facility:
          filterMainViewController.viewModel.facilityFilterState.accept(filterCase)
        case .pet:
          filterMainViewController.viewModel.petFilterState.accept(filterCase)
        }
        modalNavigationController.popToViewController(filterMainViewController, animated: true)
      }
    }
    if let message = message {
      modalNavigationController.view.makeToast(message, position: .bottom)
    }
  }
  
  func pushKeywordViewController(_ viewModel: KeywordViewModel) {
    let vc = KeywordViewController(viewModel: viewModel)
    vc.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(vc, animated: true)
  }
  
  func popToRootViewController(message: String? = nil) {
    navigationController.popToRootViewController(animated: true)
    if let message = message {
      navigationController.view.makeToast(message, position: .top)
    }
  }
}

extension SearchCoordinator: UISheetPresentationControllerDelegate {}
