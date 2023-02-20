//
//  MyPageSettingSwitchCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageSettingSwitchCell: UITableViewCell {
  static let identifier = "MyPageSettingSwitchCell"
  private let switchState = PublishRelay<Bool>()
  
  private let titleLabel = DefaultLabel(title: "", font: .title4R14, textColor: .black, textAlignment: .left)
  private let switchView = UISwitch()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MyPageSettingSwitchCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(switchView)
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16.0)
    }
    
    switchView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(title: String, switchState: Bool) {
    titleLabel.text = title
    switchView.setOn(switchState, animated: true)
  }
  
  func configure(with viewModel: MyPageSettingSwitchCellViewModel) {
    
  }
}

struct MyPageSettingSwitchCellViewModel {
  let switchState: PublishRelay<Bool>
}
