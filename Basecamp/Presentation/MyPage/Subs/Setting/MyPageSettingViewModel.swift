//
//  MyPageSettingViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import Foundation
import UserNotifications
import RxSwift
import RxCocoa
import UIKit

final class MyPageSettingViewModel: ViewModel {
  var disposeBag = DisposeBag()
  
  weak var coordinator: MyPageCoordinator?
  private let myPageUseCase: MyPageUseCase
  
  init(coordinator: MyPageCoordinator?, myPageUseCase: MyPageUseCase) {
    self.coordinator = coordinator
    self.myPageUseCase = myPageUseCase
  }
  
  struct Input {
    let viewDidLoad: Signal<Void>
    let didSelectItemAt: Signal<(MyPageSettingCase, IndexPath)>
  }
  struct Output {
    let data: Driver<[MyPageSettingCase]>
  }
  
  let switchCellViewModel = MyPageSettingSwitchCellViewModel(
    switchState: PublishRelay<Bool>()
  )
  let data = BehaviorRelay<[MyPageSettingCase]>(value: MyPageSettingCase.allCases)
  
  func transform(input: Input) -> Output {
    switchCellViewModel.switchState
      .withUnretained(self)
      .observe(on: MainScheduler.instance)
      .subscribe { owner, state in
        if state {
          UIApplication.shared.registerForRemoteNotifications()
        } else {
          UIApplication.shared.unregisterForRemoteNotifications()
          UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
          UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
      }
      .disposed(by: disposeBag)
    
    input.didSelectItemAt
      .withUnretained(self)
      .emit { owner, item in
        let (model, _) = item
        switch model {
        case .accessRight:
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
        default:
          break
        }
      }
      .disposed(by: disposeBag)
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
}

enum MyPageSettingCase: String, CaseIterable {
  case pushControl = "휴대폰 Push 알림 설정"
  case accessRight = "접근 권한 설정"
  case version = "버전 정보"
}
