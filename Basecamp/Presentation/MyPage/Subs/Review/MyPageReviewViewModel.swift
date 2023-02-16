//
//  MyPageReviewViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageReviewViewModel: ViewModel {
  weak var coordinator: MyPageCoordinator?
  private let myPageUseCase: MyPageUseCase
  
  init(coordinator: MyPageCoordinator?, myPageUseCase: MyPageUseCase) {
    self.coordinator = coordinator
    self.myPageUseCase = myPageUseCase
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
  }
  
  struct Output {
    let data: Driver<[Review]>
  }
  
  let data = BehaviorRelay<[Review]>(value: [])
  let yearState = BehaviorRelay<YearState>(value: .this)
  let viewType = BehaviorRelay<ViewType>(value: .card)
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    input.viewWillAppear
      .withUnretained(self)
      .compactMap { (owner, _) in
        owner.myPageUseCase.requestReviewData()
      }
      .bind(to: data)
      .disposed(by: disposeBag)
    
    return Output(data: data.asDriver())
  }
}

enum YearState {
  case this
  case last
  
  var startDate: Date {
    switch self {
    case .this:
      let components = DateComponents(year: 2023, month: 1, day: 1)
      let calendar = Calendar.current
      guard let startDate = calendar.date(from: components) else { return Date() }
      return startDate
    case .last:
      let components = DateComponents(year: 2022, month: 1, day: 1)
      let calendar = Calendar.current
      guard let startDate = calendar.date(from: components) else { return Date() }
      return startDate
    }
  }
  
  var endDate: Date {
    switch self {
    case .this:
      let components = DateComponents(year: 2023, month: 12, day: 31, hour: 23, minute: 59)
      let calendar = Calendar.current
      guard let endDate = calendar.date(from: components) else { return Date() }
      return endDate
    case .last:
      let components = DateComponents(year: 2022, month: 12, day: 31, hour: 23, minute: 59)
      let calendar = Calendar.current
      guard let endDate = calendar.date(from: components) else { return Date() }
      return endDate
    }
  }
  
  var rangeQuery: String {
    return "startDate BETWEEN {%@, %@}"
  }
}

enum ViewType {
  case card
  case grid
  case map
}


