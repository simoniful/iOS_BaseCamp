//
//  HomeHeaderView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit

final class HomeHeaderView: UIView {
  
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
      setupConstraints()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  
}

extension HomeHeaderView: ViewRepresentable {
    func setupView() {

    }
    
    func setupConstraints() {

    }
}
