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
    let deleteAllButtonTapped: Signal<Void>
  }
  
  struct Output {
    let data: Driver<[Review]>
    let yearState: Driver<YearState>
    let viewType: Driver<ViewType>
    let selectAlert: Signal<(String, String, Review)>
    let deleteAllAlert: Signal<(String, String)>
  }
  
  let data = BehaviorRelay<[Review]>(value: [])
  let yearState = BehaviorRelay<YearState>(value: .this)
  let viewType = BehaviorRelay<ViewType>(value: .card)
  let didSelectItemAt = PublishRelay<(Review, Int)>()
  let selectAlert = PublishRelay<(String, String, Review)>()
  let deleteConfirmTapped = PublishRelay<Review>()
  let showCampsiteTapped = PublishRelay<Review>()
  let deleteAllAlert = PublishRelay<(String, String)>()
  let deleteAllConfirmTapped = PublishRelay<Void>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    yearState
      .withUnretained(self)
      .compactMap { (owner, state) in
        owner.myPageUseCase.requestReviewData(query: state.rangeQuery, startDate: state.startDate, endDate: state.endDate)
      }
      .bind(to: data)
      .disposed(by: disposeBag)
    
    didSelectItemAt
      .withUnretained(self)
      .compactMap {(owner, item) in
        let (review, _) = item
        let result = (
          review.campsite.facltNm,
          "\(review.startDate.toString(format: "yyyy년 MM월 dd일")) ~ \(review.endDate.toString(format: "yyyy년 MM월 dd일"))",
          review
        )
        return result
      }
      .bind(to: selectAlert)
      .disposed(by: disposeBag)
    
    input.deleteAllButtonTapped
      .withUnretained(self)
      .emit { (owner, _) in
        print("Tapped All Delete")
        owner.deleteAllAlert.accept(("캠핑로그 목록 정리", "캠핑로그 목록을 비우시겠습니까?"))
      }
      .disposed(by: disposeBag)
    
    deleteAllConfirmTapped
      .withUnretained(self)
      .subscribe { owner, _ in
        owner.data.value.forEach {
          owner.myPageUseCase.deleteReviewData(review: $0)
        }
        owner.data.accept([])
      }
      .disposed(by: disposeBag)
    
    deleteConfirmTapped
      .withUnretained(self)
      .subscribe { owner, review in
        owner.myPageUseCase.deleteReviewData(review: review)
        let deleted = owner.data.value.filter { $0._id != review._id }
        owner.data.accept(deleted)
      }
      .disposed(by: disposeBag)
    
    showCampsiteTapped
      .withUnretained(self)
      .subscribe { owner, review in
        owner.coordinator?.showDetailViewController(data: .campsite(data: review.campsite))
      }
      .disposed(by: disposeBag)
    
    return Output(
      data: data.asDriver(),
      yearState: yearState.asDriver(),
      viewType: viewType.asDriver(),
      selectAlert: selectAlert.asSignal(),
      deleteAllAlert: deleteAllAlert.asSignal()
    )
  }
}

enum YearState: String, CaseIterable {
  case this = "2023"
  case last = "2022"
  
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

enum ViewType: String, CaseIterable {
  case card = "카드보기"
  case map = "지도보기"
}


