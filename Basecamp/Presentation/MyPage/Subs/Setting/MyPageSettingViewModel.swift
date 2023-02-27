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
    let pushDenyAlert: Signal<(String, String)>
    let toastSignal: Signal<String>
  }
  
  let switchCellViewModel = MyPageSettingSwitchCellViewModel(
    switchState: BehaviorRelay<Bool>(
      value: !(UserDefaults.standard.bool(forKey: UserDefaultKeyCase.isPushNotiOff))
    ),
    changeSwitch: PublishRelay<Void>()
  )
  
  let data = BehaviorRelay<[MyPageSettingCase]>(value: MyPageSettingCase.allCases)
  let pushDenyAlert = PublishRelay<(String, String)>()
  let toastSignal = PublishRelay<String>()
  
  func transform(input: Input) -> Output {
    switchCellViewModel.switchState
      .withUnretained(self)
      .subscribe { owner, switchState in
        print(switchState, "VM에서 전달받은 스위치 상태")
        if switchState {
          owner.isPushNotificationsEnabled { pushState in
            switch pushState {
            case true:
              DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                UserDefaults.standard.set(false, forKey: UserDefaultKeyCase.isPushNotiOff)
              }
              owner.toastSignal.accept("앱 실행 중 알림 설정")
            case false:
              owner.pushDenyAlert.accept(("접근 권한 설정 필요", "Push 알림에 대한 접근 권한을 바꾸어야 합니다"))
            }
          }
        } else {
          UIApplication.shared.unregisterForRemoteNotifications()
          UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
          UNUserNotificationCenter.current().removeAllDeliveredNotifications()
          UserDefaults.standard.set(true, forKey: UserDefaultKeyCase.isPushNotiOff)
          owner.toastSignal.accept("앱 실행 중 알림 해제")
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
    return Output(
      data: data.asDriver(onErrorJustReturn: []),
      pushDenyAlert: pushDenyAlert.asSignal(),
      toastSignal: toastSignal.asSignal()
    )
  }
  
  func isPushNotificationsEnabled(completion: @escaping (Bool) -> Void) {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .notDetermined, .denied:
        completion(false)
      case .authorized, .provisional, .ephemeral:
        completion(true)
      @unknown default:
        completion(false)
      }
    }
  }
}

enum MyPageSettingCase: String, CaseIterable {
  case pushControl = "앱 실행 중 알림"
  case accessRight = "접근 권한 설정"
  case version = "버전 정보"
}
