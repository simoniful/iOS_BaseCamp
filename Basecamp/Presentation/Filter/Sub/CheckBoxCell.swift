//
//  CheckBoxCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/16.
//

import UIKit
import SnapKit

class CheckboxCell: UITableViewCell {
  static let identifier = "CheckboxCell"
  
  var isCheck: Bool = false {
    didSet {
      let imageName = isCheck ? "square" : "checkmark.square.fill"
      checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
  }
  
  lazy var checkBoxButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "square"), for: .normal)
    button.isUserInteractionEnabled = false
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupViews()
    setupConstraints()
  }
  
  func setupData(data: FilterItem) {
    titleLabel.text = data.title
    let imageName = data.selected ? "checkmark.square.fill" : "square"
    checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
  }
  
  private func setupViews() {
    contentView.addSubview(checkBoxButton)
    contentView.addSubview(titleLabel)
  }
  
  private func setupConstraints() {
    checkBoxButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-16.0)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(16.0)
    }
  }
}
