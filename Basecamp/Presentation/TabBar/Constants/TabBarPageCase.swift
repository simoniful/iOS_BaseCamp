//
//  TabBarPageCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//
import Foundation

enum TabBarPageCase: String, CaseIterable {
  case home, search, list, map, mypage
  
  init?(index: Int) {
    switch index {
    case 0: self = .home
    case 1: self = .search
    case 2: self = .list
    case 3: self = .map
    case 4: self = .mypage
    default: return nil
    }
  }
  
  var pageOrderNumber: Int {
    switch self {
    case .home: return 0
    case .search: return 1
    case .list: return 2
    case .map: return 3
    case .mypage: return 4
    }
  }
  
  var pageTitle: String {
    switch self {
    case .home:
      return "홈"
    case .search:
      return "검색"
    case .list:
      return "리스트"
    case .map:
      return "지도"
    case .mypage:
      return "마이"
    }
  }
  
  func tabIconName() -> String {
    return self.rawValue
  }
}
