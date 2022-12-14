//
//  HomeView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit

final class HomeView: UIView {
  lazy var rightBarSearchButton: UIBarButtonItem = {
      let barButton = UIBarButtonItem()
      barButton.image = UIImage(systemName: "magnifyingglass")
      barButton.style = .plain
      return barButton
  }()
  
  lazy var rightBarListButton: UIBarButtonItem = {
      let barButton = UIBarButtonItem()
      barButton.image = UIImage(systemName: "list.bullet")
      barButton.style = .plain
      return barButton
  }()
  
  lazy var rightBarMapButton: UIBarButtonItem = {
      let barButton = UIBarButtonItem()
      barButton.image = UIImage(systemName: "mappin.and.ellipse")
      barButton.style = .plain
      return barButton
  }()
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
      setupConstraints()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

extension HomeView: ViewRepresentable {
    func setupView() {

    }
    
    func setupConstraints() {

    }
}
