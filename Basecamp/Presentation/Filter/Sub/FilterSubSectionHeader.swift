//
//  FilterSubSectionHeader.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/17.
//

import UIKit

final class FilterSubSectionHeader: UITableViewHeaderFooterView {
  static let identifier = "FilterSubSectionHeader"
  
  private let titleLabel = DefaultLabel(font: .systemFont(ofSize: 18, weight: .medium))
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
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
        $0.leading.equalToSuperview().offset(16.0)
      }
  }
  
  func setData(header: String) {
    self.titleLabel.text = header
  }
}
