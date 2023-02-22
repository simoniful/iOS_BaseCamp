//
//  AppAppearance.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import Toast_Swift

final class AppAppearance {
  
  static func setupAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.titlePositionAdjustment = .init(horizontal: -max(UIScreen.main.bounds.width, UIScreen.main.bounds.height), vertical: 0)
    appearance.configureWithDefaultBackground()
    appearance.backgroundColor = .systemBackground
    appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
    appearance.shadowImage = UIImage(named: "shadow")
    appearance.shadowColor = nil
    
    let backImage = UIImage(named: "backNarrow")
    appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().tintColor = .label
    UINavigationBar.appearance().barTintColor = .label
    
    var style = ToastStyle()
    style.messageFont = .body4R12
    style.messageColor = .white
    style.backgroundColor = .black
    style.titleAlignment = .center
    ToastManager.shared.style = style
  }
}
