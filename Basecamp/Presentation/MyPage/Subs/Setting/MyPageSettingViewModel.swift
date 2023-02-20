//
//  MyPageSettingViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageSettingViewModel: ViewModel {
  var disposeBag = DisposeBag()
  
  struct Input {
    let viewDidLoad: Signal<Void>
    
  }
  struct Output {
    let data: Driver<[MyPageSettingCase]>
  }
  
  let data = BehaviorRelay<[MyPageSettingCase]>(value: MyPageSettingCase.allCases)
  
  func transform(input: Input) -> Output {
    
    
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
}

enum MyPageSettingCase: String, CaseIterable {
  case pushControl = "휴대폰 Push 알림 설정"
  case accessRight = "접근 권한 설정"
  case version = "버전 정보"
}
