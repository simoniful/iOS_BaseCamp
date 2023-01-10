//
//  CampsiteInfoStackView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/09.
//

import UIKit
import SnapKit

final class DetailInfoStackView: UIStackView {
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    self.translatesAutoresizingMaskIntoConstraints = true
    self.axis = .vertical
    self.alignment = .fill
    self.distribution = .fill
    self.spacing = 0
    self.layer.cornerRadius = 8.0
    self.clipsToBounds = true
    self.layer.borderColor = UIColor.main.cgColor
    self.layer.borderWidth = 1.0
    
    [].forEach {
      self.addArrangedSubview($0)
    }
  }
  
  func setData(data: DetailCampsiteInfoItem) {
    
  }
  
  private func makeStack(first: UIView, second: UIView, axis:  NSLayoutConstraint.Axis) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 0
    
    [first, second].forEach {
      stackView.addArrangedSubview($0)
    }
    
    if axis == .vertical {
      first.snp.makeConstraints {
        $0.height.equalTo(36.0)
      }
      
      second.snp.makeConstraints {
        $0.height.equalTo(36.0)
      }
    }

    return stackView
  }
}
