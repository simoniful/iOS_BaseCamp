//
//  DetailAroundTabmanSubViewController.swift.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit

final class DetailAroundTabmanSubViewController: UIViewController {
  private let viewModel: DetailViewModel
  
  init(viewModel: DetailViewModel, locationData: DetailAroundItem) {
    self.viewModel = viewModel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
