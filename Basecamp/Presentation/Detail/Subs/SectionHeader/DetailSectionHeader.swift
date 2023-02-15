//
//  DetailSectionHeader.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/04.
//

import UIKit
import SnapKit

class DetailSectionHeader: UICollectionReusableView {
  static let identifier = "DetailSectionHeader"
  
  private lazy var titleLabel = DefaultLabel(font: .systemFont(ofSize: 20, weight: .bold))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DetailSectionHeader: ViewRepresentable {
  func setupView() {
    [titleLabel].forEach {
      self.addSubview($0)
    }
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }
  }
  
  func setupData(header: String) {
    self.titleLabel.text = header
  }
}
