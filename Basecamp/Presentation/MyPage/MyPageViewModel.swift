//
//  MyPageViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/12.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModel {
  weak var coordinator: MyPageCoordinator?
  private let myPageUseCase: MyPageUseCase
  
  init(coordinator: MyPageCoordinator?, myPageUseCase: MyPageUseCase) {
    self.coordinator = coordinator
    self.myPageUseCase = myPageUseCase
  }
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let didSelectItemAt: Signal<(MyMenuCase, IndexPath)>
  }
  
  struct Output {
    let data: Driver<[MyMenuCase]>
  }
  
  // private lazy var likeViewModel =
  
  
  var disposeBag = DisposeBag()
  private let data = BehaviorRelay<[MyMenuCase]>(value: [.notice, .like(0), .review(0), .info, .setting])
  
  func transform(input: Input) -> Output {
    input.didSelectItemAt
      .emit { [weak self] (menu, index) in
        self?.coordinator?.showSubViewController(type: menu)
      }
      .disposed(by: disposeBag)
    
    input.viewWillAppear
      .withUnretained(self)
      .emit { (owner, _) in
        let count = owner.myPageUseCase.requestRealmData()
        owner.data.accept([.notice, .like(count.0), .review(count.1), .info, .setting])
      }
      .disposed(by: disposeBag)
    
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
}

enum MyMenuCase {
  case notice
  case like(Int)
  case review(Int)
  case info
  case setting
  
  var title: String {
    switch self {
    case .notice:
      return "공지사항"
    case .like:
      return "관심 캠핑장"
    case .review:
      return "캠핑로그"
    case .info:
      return "정보"
    case .setting:
      return "설정"
    }
  }

  var icon: String {
    switch self {
    case .notice:
      return "note.text"
    case .like:
      return "heart.square.fill"
    case .review:
      return "books.vertical.fill"
    case .info:
      return "info.circle"
    case .setting:
      return "gearshape.2.fill"
    }
  }
}
