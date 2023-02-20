//
//  MyPageInfoViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageInfoViewModel: ViewModel {
  var disposeBag = DisposeBag()
  
  weak var coordinator: MyPageCoordinator?
  private let myPageUseCase: MyPageUseCase
  
  init(coordinator: MyPageCoordinator?, myPageUseCase: MyPageUseCase) {
    self.coordinator = coordinator
    self.myPageUseCase = myPageUseCase
  }
  
  struct Input {
    let viewDidLoad: Signal<Void>
    let didSelectItemAt: Signal<(MyPageInfoCase, IndexPath)>
  }
  
  struct Output {
    let data: Driver<[MyPageInfoCase]>
  }
  
  let data = BehaviorRelay<[MyPageInfoCase]>(value: MyPageInfoCase.allCases)
  
  func transform(input: Input) -> Output {
    input.didSelectItemAt
      .withUnretained(self)
      .emit { (owner, item) in
        let (infoCase, _) = item
        owner.coordinator?.showInfoWebViewController(with: infoCase)
      }
      .disposed(by: disposeBag)
    
    return Output(data: data.asDriver())
  }
}

enum MyPageInfoCase: String, CaseIterable {
  case termsOfUse = "이용약관"
  case privacy = "개인정보 처리방침"
  case locationBased = "위치기반정보 이용약관"
  
  var url: String {
    switch self {
    case .termsOfUse:
      return "https://five-pedestrian-462.notion.site/BaseCamping-0b2d6a9fb65541ed97178a9fd30850b4"
    case .privacy:
      return "https://five-pedestrian-462.notion.site/BaseCamping-84bd95bad78846b1be1951d89fd1cf00"
    case .locationBased:
      return "https://five-pedestrian-462.notion.site/BaseCamping-69d99552edb34a76af22ecbd0ea23ea3"
    }
  }
}
