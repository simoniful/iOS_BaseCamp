//
//  HomeViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import UIKit

final class HomeViewController: UIViewController {
  
  private let homeView = HomeView()
  private let viewModel: HomeViewModel
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("HomeViewController: fatal error")
  }
  
  override func loadView() {
    super.loadView()
    view = homeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
  }
}

private extension HomeViewController {
  func setupNavigationBar() {
    setupLogo()
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItems = [
      homeView.rightBarMapButton,
      homeView.rightBarListButton,
      homeView.rightBarSearchButton
    ]
  }
  
  func setupLogo() {
    let logoImage = UIImage.init(named: "logo")
      let logoImageView = UIImageView.init(image: logoImage)
      logoImageView.frame = CGRect(x: 0.0, y: 0.0,  width: 44, height: 44.0)
      logoImageView.contentMode = .scaleAspectFit
      let imageItem = UIBarButtonItem.init(customView: logoImageView)
      let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 44)
      let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 44)
       heightConstraint.isActive = true
       widthConstraint.isActive = true
       navigationItem.leftBarButtonItem = imageItem
  }
}

