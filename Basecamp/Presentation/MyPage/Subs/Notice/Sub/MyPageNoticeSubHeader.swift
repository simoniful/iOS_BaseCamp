//
//  MyPageNoticeSubHeader.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/15.
//

import UIKit
import SnapKit

final class MyPageNoticeSubHeader: UITableViewHeaderFooterView {
  static let identifier = "MyPageNoticeSubHeader"
  
  private lazy var badgeLabel: StackingLabel = {
    let label = StackingLabel(title: "", font: .systemFont(ofSize: 12.0, weight: .bold), textColor: .white, textAlignment: .left, backgroundColor: .mainStrong, padding: .init(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0))
    label.layer.cornerRadius = 8.0
    label.clipsToBounds = true
    return label
  }()
  
  private let titleLabel = DefaultLabel(font: .systemFont(ofSize: 18, weight: .medium))
  private let dateLabel = DefaultLabel(title: "", font: .body3R14, textColor: .gray7)
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MyPageNoticeSubHeader: ViewRepresentable {
  func setupView() {
    [badgeLabel, titleLabel, dateLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    badgeLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(16.0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(badgeLabel.snp.bottom).offset(4.0)
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.bottom.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(notice: Notice) {
    titleLabel.text = notice.title
    dateLabel.text = notice.regDate.toString(format: "yyyy.MM.dd")
    switch notice.type {
    case .notice:
      badgeLabel.text = "공지"
      badgeLabel.backgroundColor = .mainStrong
    case .patchNote:
      badgeLabel.text = "패치노트"
      badgeLabel.backgroundColor = .mainWeak
    }
  }
}
