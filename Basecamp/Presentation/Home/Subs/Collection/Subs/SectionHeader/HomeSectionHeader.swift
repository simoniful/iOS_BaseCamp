//
//  HomeSectionHeader.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import UIKit

final class HomeSectionHeader: UICollectionReusableView {
  static let identifier = "HomeSectionHeader"
  
  private let titleLabel = DefaultLabel(font: .systemFont(ofSize: 20, weight: .bold))
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      attribute()
      layout()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {

  }
  
  private func layout() {
      [titleLabel].forEach {
          self.addSubview($0)
      }
      
      titleLabel.snp.makeConstraints {
          $0.centerY.equalToSuperview()
          $0.leading.equalToSuperview()
      }
  }
  
  func setData(header: String) {
    self.titleLabel.text = header
  }
}
