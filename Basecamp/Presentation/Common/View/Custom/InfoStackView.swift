//
//  InfoStackLabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import UIKit
import SnapKit

final class InfoStackView: UIStackView {
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 14)
    label.text = "카테고리"
    return label
  }()
  
  private lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.text = "내용"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {

    
    self.translatesAutoresizingMaskIntoConstraints = true
    self.translatesAutoresizingMaskIntoConstraints = true
    self.axis = .vertical
    self.alignment = .fill
    self.distribution = .fill
    self.spacing = 0
    self.layer.cornerRadius = 8.0
    self.clipsToBounds = true
    self.layer.borderColor = UIColor(red: 165, green: 185, blue: 171, alpha: 1.0).cgColor
    self.layer.borderWidth = 1.0
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.width.equalTo(self.snp.width).multipliedBy(0.3)
    }
  }
  
  func setData(title: String, content: String) {
    titleLabel.text = title
    contentLabel.text = content
  }
}
