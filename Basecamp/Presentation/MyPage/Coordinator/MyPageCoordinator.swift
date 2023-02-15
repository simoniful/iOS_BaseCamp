//
//  MyPageCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/12.
//

import UIKit
import Toast

final class MyPageCoordinator: NSObject, Coordinator {
  weak var finishDelegate: CoordinatorFinishDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var type: CoordinatorStyleCase = .myPage
 
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = MyPageViewController(
      viewModel: MyPageViewModel(
        coordinator: self,
        myPageUseCase: MyPageUseCase(
          realmRepository: RealmRepository()
        )
      )
    )
    vc.title = "마이메뉴"
    navigationController.pushViewController(vc, animated: true)
  }
  
  func showDetailViewController(data: DetailStyle) {
    let detailCoordinator = DetailCoordinator(self.navigationController)
    detailCoordinator.data = data
    detailCoordinator.parentCoordinator = self
    self.store(coordinator: detailCoordinator)
    detailCoordinator.start()
  }
  
  func showSubViewController(type: MyMenuCase) {
    switch type {
    case .notice:
      let viewController = MyPageNoticeViewController(
        viewModel: MyPageNoticeViewModel(
          coordinator: self
        )
      )
      viewController.title = "공지사항"
      navigationController.pushViewController(viewController, animated: true)
    case .like:
      break
    case .review:
      break
    case .info:
      break
    case .setting:
      break
    }
  }
  
  func showSubNoticeViewController(notice: Notice) {
    let viewController = MyPageNoticeSubViewController()
    viewController.title = "공지사항"
    viewController.notice = notice
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
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

extension MyPageCoordinator: UINavigationControllerDelegate {
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
