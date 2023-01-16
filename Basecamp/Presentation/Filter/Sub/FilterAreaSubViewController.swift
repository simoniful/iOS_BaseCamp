//
//  FilterSubViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/16.
//

import UIKit

final class FilterAreaSubViewController: UIViewController {
  public var viewModel: FilterSubViewModel
  
  private let tableView = UITableView(frame: .zero, style: .plain)
  
  init(viewModel: FilterSubViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func bind() {

  }
}
