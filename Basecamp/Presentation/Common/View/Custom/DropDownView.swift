//
//  DropDownView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/25.
//

import UIKit
import SnapKit

final class DropDownView: UIView {
  public let textField: UITextField = {
    let textField = UITextField()
    textField.font = .systemFont(ofSize: 18.0, weight: .medium)
    return textField
  }()
  
  public let iconImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()
  
  public let selectButton = UIButton()
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    [textField, iconImageView, selectButton].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    textField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(iconImageView.snp.leading)
    }
    
    iconImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.width.height.equalTo(20.0)
    }
    
    selectButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  public func setupSelected() {
    
  }
  
  public func setupCanceled() {
    
  }
  
  
}
