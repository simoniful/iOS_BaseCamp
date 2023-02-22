//
//  MapCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/29.
//

import UIKit
import Toast_Swift

final class MapCoordinator: NSObject, Coordinator, FilterModalCoordinator {
  weak var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .map
  var modalNavigationController = UINavigationController()
  
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
    let detailCoordinator = DetailCoordinator(self.navigationController)
    detailCoordinator.data = data
    detailCoordinator.parentCoordinator = self
//    detailCoordinator.isCompleted = { [weak self] in
//      self?.free(coordinator: detailCoordinator)
//    }
    self.store(coordinator: detailCoordinator)
    detailCoordinator.start()
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
  
  func popToFilterMainViewController(message: String?, filterCase: FilterCase) {
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
  
  func popToRootViewController(message: String? = nil) {
    navigationController.popToRootViewController(animated: true)
    if let message = message {
      navigationController.view.makeToast(message, position: .top)
    }
  }
}

extension MapCoordinator: UISheetPresentationControllerDelegate {}
