//
//  Locale.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation

enum Region: String {
  case 서울특별시
  case 경기도
  case 인천광역시
  case 강원도
  case 대전광역시
  case 광주광역시
  case 대구광역시
  case 부산광역시
  case 울산광역시
  case 제주특별자치도
  case 세종특별자치시
  case 충청북도
  case 충청남도
  case 경상북도
  case 경상남도
  case 전라북도
  case 전라남도
  
  var abbreviation: String {
    switch self {
    case .서울특별시: return "서울"
    case .경기도: return "경기"
    case .인천광역시: return "인천"
    case .강원도: return "강원"
    case .대전광역시: return "대전"
    case .광주광역시: return "광주"
    case .대구광역시: return "대구"
    case .부산광역시: return "부산"
    case .울산광역시: return "울산"
    case .제주특별자치도: return "제주"
    case .세종특별자치시: return "세종"
    case .충청북도: return "충북"
    case .충청남도: return "충남"
    case .경상북도: return "경북"
    case .경상남도: return "경남"
    case .전라북도: return "전북"
    case .전라남도: return "전남"
    }
  }
}
