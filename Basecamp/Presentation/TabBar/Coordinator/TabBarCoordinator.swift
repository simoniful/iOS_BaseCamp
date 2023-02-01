//
//  TabBarCoordinator.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit

final class TabBarCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var tabBarController: UITabBarController
  var type: CoordinatorStyleCase = .tab
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    navigationController.setNavigationBarHidden(true, animated: false)
    self.tabBarController = UITabBarController()
  }
  
  func start() {
    let pages: [TabBarPageCase] = TabBarPageCase.allCases
    let controllers: [UINavigationController] = pages.map({
      self.createTabNavigationController(of: $0)
    })
    self.configureTabBarController(with: controllers)
  }
  
  func currentPage() -> TabBarPageCase? {
    TabBarPageCase(index: self.tabBarController.selectedIndex)
  }
  
  func selectPage(_ page: TabBarPageCase) {
    self.tabBarController.selectedIndex = page.pageOrderNumber
  }
  
  func setSelectedIndex(_ index: Int) {
    guard let page = TabBarPageCase(index: index) else { return }
    self.tabBarController.selectedIndex = page.pageOrderNumber
  }
  
  private func configureTabBarController(with tabViewControllers: [UIViewController]) {
    self.tabBarController.setViewControllers(tabViewControllers, animated: true)
    self.tabBarController.selectedIndex = TabBarPageCase.home.pageOrderNumber
    self.tabBarController.view.backgroundColor = .systemBackground
    self.tabBarController.tabBar.backgroundColor = .systemBackground
    self.tabBarController.tabBar.tintColor = .main
    self.tabBarController.tabBar.unselectedItemTintColor = .systemGray
    self.changeAnimation()
    self.navigationController.pushViewController(tabBarController, animated: true)
  }
  
  private func configureTabBarItem(of page: TabBarPageCase) -> UITabBarItem {
    return UITabBarItem(
      title: page.pageTitle,
      image: UIImage(systemName: page.tabIconName()),
      tag: page.pageOrderNumber
    )
  }
  
  private func createTabNavigationController(of page: TabBarPageCase) -> UINavigationController {
    let tabNavigationController = UINavigationController()
    tabNavigationController.setNavigationBarHidden(false, animated: false)
    tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
    connectTabCoordinator(of: page, to: tabNavigationController)
    return tabNavigationController
  }
  
  private func connectTabCoordinator(of page: TabBarPageCase, to tabNavigationController: UINavigationController) {
    switch page {
    case .home:
      let homeCoordinator = HomeCoordinator(tabNavigationController)
      homeCoordinator.delegate = self
      self.childCoordinators.append(homeCoordinator)
      homeCoordinator.isCompleted = { [weak self] in
        self?.free(coordinator: homeCoordinator)
      }
      homeCoordinator.start()
    case .search:
      let searchCoordinator = SearchCoordinator(tabNavigationController)
      searchCoordinator.delegate = self
      self.childCoordinators.append(searchCoordinator)
      searchCoordinator.start()
    case .list:
      let listCoordinator = ListCoordinator(tabNavigationController)
      listCoordinator.delegate = self
      self.childCoordinators.append(listCoordinator)
      listCoordinator.start()
    case .map:
      let mapCoordinator = MapCoordinator(tabNavigationController)
      mapCoordinator.delegate = self
      self.childCoordinators.append(mapCoordinator)
      mapCoordinator.start()
    default:
      break
    }
  }
}

extension TabBarCoordinator: CoordinatorDelegate {
  func didFinish(childCoordinator: Coordinator) {
    self.childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    if childCoordinator.type == .myPage {
      self.navigationController.viewControllers.removeAll()
      self.delegate?.didFinish(childCoordinator: self)
    }
  }
}
