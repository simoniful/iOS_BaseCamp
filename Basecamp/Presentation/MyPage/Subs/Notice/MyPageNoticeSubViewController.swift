//
//  MyPageNoticeSubViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/14.
//

import UIKit
 
final class MyPageNoticeSubViewController: UIViewController {
  public var notice: Notice?
  
  private let tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension MyPageNoticeSubViewController: ViewRepresentable {
  func setupView() {
    
    
  }
  
  func setupConstraints() {
    
  }
}


