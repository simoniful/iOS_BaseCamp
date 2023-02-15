//
//  FilterSubSectionHeader.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/17.
//

import UIKit
import SnapKit

final class FilterSubSectionHeader: UITableViewHeaderFooterView {
  static let identifier = "FilterSubSectionHeader"
  
  private let titleLabel = DefaultLabel(font: .systemFont(ofSize: 18, weight: .medium))
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

extension FilterSubSectionHeader: ViewRepresentable {
  func setupView() {
    [titleLabel].forEach {
        self.addSubview($0)
    }
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
        $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16.0)
    }
  }
  
  func setupData(header: String) {
    self.titleLabel.text = header
  }
}
