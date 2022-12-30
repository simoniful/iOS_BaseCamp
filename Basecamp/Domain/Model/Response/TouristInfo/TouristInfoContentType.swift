//
//  TouristInfoContentType.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

enum TouristInfoContentType: Int, CaseIterable {
  case touristSpot = 12
  case cultureFacilities = 14
  case festival = 15
  case leisure = 28
  case shoppingSpot = 38
  case restaurant = 39
  
  var koreanTitle: String {
    switch self {
    case .touristSpot:
      return "관광지"
    case .cultureFacilities:
      return "문화시설"
    case .festival:
      return "축제/행사"
    case .leisure:
      return "레저"
    case .shoppingSpot:
      return "쇼핑"
    case .restaurant:
      return "맛집"
    }
  }
}
