//
//  AppDelegate.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import UserNotifications
import DropDown
import GoogleMaps
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    if UserDefaults.standard.bool(forKey: UserDefaultKeyCase.isNotFirstUser) {
      print("Init DB Setting OK")
          // 실제 버전 구분에 대한 플래그 작성 필요 - 날짜
          // old Realm Data와 new Json 데이터 코더블 파싱 후
          // Set 형식 변환 후 new 데이터에서 여집합 부분만 추가
    } else {
      RealmRepository.saveFromLocalJson()
      UserDefaults.standard.set(true, forKey: UserDefaultKeyCase.isNotFirstUser)
    }
    
    sleep(4)
    
    AppAppearance.setupAppearance()
    GMSServices.provideAPIKey(APIKey.googleMapId.rawValue)
    GMSServices.setMetalRendererEnabled(true)
    
    UNUserNotificationCenter.current().delegate = self

    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    application.registerForRemoteNotifications()
  
    DropDown.startListeningToKeyboard()
    KakaoSDK.initSDK(appKey: APIKey.kakaoNative.rawValue)
    
    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    private func registerRemoteNotification() {}
}


