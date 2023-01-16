//
//  SearchHeader.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchHeader: UITableViewHeaderFooterView {
  static let identifier = "SearchHeader"
  
  let disposeBag = DisposeBag()
  
  private let titleLabel = DefaultLabel(title: "필터", font: .display1R20)
  
  private lazy var filterButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func bind(_ viewModel: SearchHeaderViewModel) {
    filterButton.rx.tap
      .bind(to: viewModel.sortButtonTapped)
      .disposed(by: disposeBag)
  }
}

extension SearchHeader: ViewRepresentable {
  func setupView() {
    [titleLabel, filterButton].forEach {
      addSubview($0)
    }
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16.0)
    }
    
    filterButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-8.0)
      $0.width.height.equalTo(44.0)
    }
  }
}

