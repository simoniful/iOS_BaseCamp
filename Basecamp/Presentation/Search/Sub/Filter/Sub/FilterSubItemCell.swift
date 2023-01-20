//
//  CheckBoxCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FilterSubItemCell: UITableViewCell {
  static let identifier = "FilterSubItemCell"
  
  var viewModel = FilterItemViewModel(FilterItem.empty)
  var disposeBag = DisposeBag()
  
  lazy var checkBoxButton: CheckButton = {
    let button = CheckButton()
    button.setImage(UIImage(systemName: "square"), for: .normal)
    button.tintColor = .paleBlue
    return button
  }()
  
  lazy var titleLabel = DefaultLabel(font: .body2R16)
  
  func bind(item: FilterItem) {
    viewModel = FilterItemViewModel(item)
    setupBindings()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  func setupBindings() {
    let items = viewModel.items.asDriver()
    
    items.map { $0.title }
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.checkImageString.asDriver(onErrorJustReturn: "square")
      .map { UIImage(systemName: $0) }
      .drive(checkBoxButton.rx.backgroundImage())
      .disposed(by: disposeBag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupViews()
    setupConstraints()
  }

  func setupData(data: FilterItem) {
    titleLabel.text = data.title
    let imageName = data.selected ? "checkmark.square.fill" : "square"
    checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
  }

  private func setupViews() {
    contentView.addSubview(checkBoxButton)
    contentView.addSubview(titleLabel)
  }

  private func setupConstraints() {
    checkBoxButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-16.0)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(16.0)
    }
  }
}

class FilterItemViewModel: NSObject {
    var items = BehaviorRelay<FilterItem>(value: FilterItem.empty)
    var disposeBag = DisposeBag()
    
    init(_ item: FilterItem) {
        _ = BehaviorSubject<FilterItem>.just(item)
            .take(1)
            .subscribe(onNext: self.items.accept(_:))
            .disposed(by: disposeBag)
    }
    
    lazy var checkImageString: Observable<String> = self.items.map { return $0.selected ? "checkmark.square.fill" : "square" }
}

class CheckButton : UIButton {
  var indexPath: IndexPath?
}
