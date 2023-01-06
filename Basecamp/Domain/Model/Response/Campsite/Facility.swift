//
//  Facility.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/06.
//

import Foundation

enum Facility: String {
  case 온수
  case 마트 = "마트.편의점"
  case 운동장
  case 놀이터
  case 물놀이장
  case 운동시설
  case 무선인터넷
  case 산책로
  case 장작판매
  case 전기
  case 트렘폴린
  
  var engName: String {
    switch self {
    case .온수:
      return "hotwater"
    case .마트:
      return "mart"
    case .운동장:
      return "ground"
    case .놀이터:
      return "playzone"
    case .물놀이장:
      return "pool"
    case .운동시설:
      return "sports"
    case .무선인터넷:
      return "wifi"
    case .산책로:
      return "walk"
    case .장작판매:
      return "wood"
    case .전기:
      return "bolt"
    case .트렘폴린:
      return "tramp"
    }
  }
  
  var iconName: String {
    return "ico_\(self.engName)"
  }
}
