//
//  KeywordSearchBar.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class KeywordSearchBar: UISearchBar {
  let disposeBag = DisposeBag()
  let searchButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    attribute()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(_ viewModel: KeywordSearchBarViewModel) {
    self.rx.text
      .bind(to: viewModel.queryText)
      .disposed(by: disposeBag)
    
    // 서치바의 서치버튼이 탭 되었을 경우
    // 커스텀 버튼이 탭 되었을 경우
    Observable<Void>
      .merge(
        self.rx.searchButtonClicked.asObservable(),
        searchButton.rx.tap.asObservable()
      )
      .bind(to: viewModel.searchButtonTapped)
      .disposed(by: disposeBag)
    
    // 키보드 내림
    viewModel.searchButtonTapped
      .asSignal()
      .emit(to: self.rx.endEditing)
      .disposed(by: disposeBag)
  }
  
  func attribute() {
    searchButton.setImage(UIImage(named: "magnifying"), for: .normal)
    searchButton.tintColor = .black
    self.placeholder = "캠핑장 이름"
    self.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: UISearchBar.Icon.search)
    self.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    self.searchTextField.font = .body3R14
  }
  
  func layout() {
    addSubview(searchButton)
    
    searchTextField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(12)
      $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
      $0.centerY.equalToSuperview()
    }
    
    searchButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(12)
    }
  }
}

extension Reactive where Base: KeywordSearchBar {
  var endEditing: Binder<Void> {
    return Binder(base) { base, _ in
      base.endEditing(true)
    }
  }
}
