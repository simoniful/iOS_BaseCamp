//
//  HomeViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import UIKit

final class HomeViewController: UIViewController {
  
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
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }
}

