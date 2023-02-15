//
//  MyPageNoticeCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import UIKit
import SnapKit

final class MyPageNoticeCell: UITableViewCell {
  static let identifier = "MyPageNoticeCell"
  
  private lazy var badgeLabel: StackingLabel = {
    let label = StackingLabel(title: "", font: .systemFont(ofSize: 12.0, weight: .bold), textColor: .white, textAlignment: .left, backgroundColor: .mainStrong, padding: .init(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0))
    label.layer.cornerRadius = 8.0
    label.clipsToBounds = true
    return label
  }()
  
  private let titleLabel = DefaultLabel(title: "", font: .title2R16, textColor: .black, textAlignment: .left)
  private let dateLabel = DefaultLabel(title: "", font: .body4R12, textColor: .gray7, textAlignment: .left)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MyPageNoticeCell: ViewRepresentable {
  func setupView() {
    [badgeLabel, titleLabel, dateLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    badgeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16.0)
      $0.leading.equalToSuperview().offset(16.0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(badgeLabel.snp.bottom)
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.bottom.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(data: Notice) {
    titleLabel.text = data.title
    switch data.type {
    case .notice:
      badgeLabel.text = "공지"
      badgeLabel.backgroundColor = .mainStrong
    case .patchNote:
      badgeLabel.text = "패치노트"
      badgeLabel.backgroundColor = .mainWeak
    }
    dateLabel.text = data.regDate.toString(format: "yyyy.MM.dd")
  }
}
