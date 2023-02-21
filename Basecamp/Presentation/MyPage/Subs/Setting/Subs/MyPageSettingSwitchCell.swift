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
  public var disposeBag = DisposeBag()
//  private let switchState = PublishRelay<Bool>()

  private let titleLabel = DefaultLabel(title: "", font: .body1M16, textColor: .black, textAlignment: .left)
  private let switchView = UISwitch()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
}

extension MyPageSettingSwitchCell: ViewRepresentable {
  func setupView() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(switchView)
//
//    switchView.rx.isOn
//      .bind(to: switchState)
//      .disposed(by: disposeBag)
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalTo(switchView.snp.centerY)
      $0.leading.equalToSuperview().offset(20.0)
    }
    
    switchView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8.0)
      $0.trailing.equalToSuperview().offset(-20.0)
      $0.bottom.equalToSuperview().offset(-8.0)
    }
  }
  
  func setupData(title: String, state: Bool) {
    titleLabel.text = title
    switchView.isOn = state
  }
  
  func configure(with viewModel: MyPageSettingSwitchCellViewModel) {
//    viewModel.switchState
//      .bind(to: switchView.rx.isOn)
//      .disposed(by: disposeBag)
    
    switchView.rx.isOn
      .bind(to: viewModel.switchState)
      .disposed(by: disposeBag)
  }
}

struct MyPageSettingSwitchCellViewModel {
  let switchState: PublishRelay<Bool>
}
