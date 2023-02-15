//
//  MyPageNoticeSubCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/15.
//

import UIKit
import SnapKit

final class MyPageNoticeSubCell: UITableViewCell {
  static let identifier = "MyPageNoticeSubCell"
  
  private let contentLabel = DefaultLabel(title: "", font: .title4R14, textColor: .black, textAlignment: .left)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MyPageNoticeSubCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(contentLabel)
  }
  
  func setupConstraints() {
    contentLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(16.0)
    }
  }
  
  func setupData(data: Notice) {
    contentLabel.text = data.content
  }
}
