//
//  InfoStackLabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import UIKit
import SnapKit

final class InfoStackLabel: UIStackView {
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
    self.addArrangedSubview(titleLabel)
    self.addArrangedSubview(contentLabel)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.axis = .horizontal
    self.distribution = .fillProportionally
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
