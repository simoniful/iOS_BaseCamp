//
//  Area.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation

enum Area: String, CaseIterable {
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
  
  var areaCode: Int {
    switch self {
    case .서울특별시:
      return 1
    case .경기도:
      return 31
    case .인천광역시:
      return 2
    case .강원도:
      return 32
    case .대전광역시:
      return 3
    case .광주광역시:
      return 5
    case .대구광역시:
      return 4
    case .부산광역시:
      return 6
    case .울산광역시:
      return 7
    case .제주특별자치도:
      return 39
    case .세종특별자치시:
      return 8
    case .충청북도:
      return 33
    case .충청남도:
      return 34
    case .경상북도:
      return 35
    case .경상남도:
      return 36
    case .전라북도:
      return 37
    case .전라남도:
      return 38
    }
  }
}

enum SeoulSub: String, CaseIterable {
  case 종로구
  case 중구
  case 용산구
  case 성동구
  case 광진구
  case 동대문구
  case 중량구
  case 성북구
  case 강북구
  case 도봉구
  case 노원구
  case 은평구
  case 서대문구
  case 마포구
  case 양천구
  case 강서구
  case 구로구
  case 금천구
  case 영등포구
  case 동작구
  case 관악구
  case 서초구
  case 강남구
  case 송파구
  case 강동구
}

enum GyeonggiSub: String, CaseIterable {
  case 수원시
}






struct Sigungu {
  let rnum: Int?
  let code: String?
  let name: String?
}
