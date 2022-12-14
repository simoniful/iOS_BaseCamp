//
//  HomeView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import UIKit

final class HomeView: UIView {
  
  
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
