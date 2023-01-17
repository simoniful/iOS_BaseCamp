//
//  Area.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation

enum Area: String, CaseIterable {
//  static var allCases: [Area] {
//    return [
//      .서울특별시(nil), .경기도(nil), .인천광역시(nil),
//      .강원도(nil), .대전광역시(nil),
//      .광주광역시(nil), .대구광역시(nil), .부산광역시(nil),
//      .울산광역시(nil), .제주특별자치도(nil), .세종특별자치시(nil),
//      .충청북도(nil), .충청남도(nil), .경상북도(nil),
//      .경상남도(nil), .전라북도(nil), .전라남도(nil)
//    ]
//  }
  
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
//
//  var name: String {
//    switch self {
//    case .서울특별시:
//      return "서울특별시"
//    case .경기도:
//      return "경기도"
//    case .인천광역시:
//      return "인천광역시"
//    case .강원도:
//      return "강원도"
//    case .대전광역시:
//      return "대전광역시"
//    case .광주광역시:
//      return "광주광역시"
//    case .대구광역시:
//      return "대구광역시"
//    case .부산광역시:
//      return "부산광역시"
//    case .울산광역시:
//      return "울산광역시"
//    case .제주특별자치도:
//      return "제주특별자치도"
//    case .세종특별자치시:
//      return "세종특별자치시"
//    case .충청북도:
//      return "충청북도"
//    case .충청남도:
//      return "충청남도"
//    case .경상북도:
//      return "경상북도"
//    case .경상남도:
//      return "경상남도"
//    case .전라북도:
//      return "전라북도"
//    case .전라남도:
//      return "전라남도"
//    }
//  }
  
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

enum SeoulSigungu: String, CaseIterable {
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

enum GyeonggiSigungu: String, CaseIterable {
  case 수원시
  case 성남시
  case 의정부시
  case 부천시
  case 광명시
  case 동두천시
  case 평택시
  case 안산시
  case 고양시
  case 과천시
  case 구리시
  case 남양주시
  case 오산시
  case 시흥시
  case 군포시
  case 의왕시
  case 하남시
  case 용인시
  case 파주시
  case 이천시
  case 안성시
  case 김포시
  case 화성시
  case 광주시
  case 양주시
  case 포천시
  case 여주시
  case 연천군
  case 가평군
  case 양평군
}

enum InCheonSigungu: String, CaseIterable {
  case 중구
  case 동구
  case 미추홀구
  case 연수구
  case 남동구
  case 부평구
  case 계양구
  case 서구
  case 강화군
  case 옹진군
}

enum GangwonSigungu: String, CaseIterable {
  case 춘천시
  case 원주시
  case 강릉시
  case 동해시
  case 태백시
  case 속초시
  case 삼척시
  case 홍천군
  case 횡성군
  case 영월군
  case 평창군
  case 정선군
  case 철원군
  case 화천군
  case 양구군
  case 인제군
  case 고성군
  case 양양군
}
              
enum DaeJeonSigungu: String, CaseIterable {
  case 동구
  case 중구
  case 서구
  case 유성구
  case 대덕구
}

enum SejongSigungu: String, CaseIterable {
  case 세종특별자치시
}

enum GwangjuSigungu: String, CaseIterable {
  case 동구
  case 서구
  case 남구
  case 북구
  case 광산구
}

enum DaeguSigungu: String, CaseIterable {
  case 중구
  case 동구
  case 서구
  case 남구
  case 북구
  case 수성구
  case 달서구
  case 달성군
}

enum BusanSigungu: String, CaseIterable {
  case 중구
  case 서구
  case 동구
  case 영도구
  case 부산진구
  case 동래구
  case 남구
  case 북구
  case 강서구
  case 해운대구
  case 사하구
  case 금정구
  case 연제구
  case 수영구
  case 사상구
  case 기장군
}

enum UlsanSigungu: String, CaseIterable {
  case 중구
  case 남구
  case 동구
  case 북구
  case 울주군
}

enum JejuSigungu: String, CaseIterable {
  case 제주시
  case 서귀포시
}

enum ChungbukSigungu: String, CaseIterable {
  case 청주시
  case 충주시
  case 제천시
  case 보은군
  case 옥천군
  case 영동군
  case 증평군
  case 진천군
  case 괴산군
  case 음성군
  case 단양군
}

enum ChungnamSigungu: String, CaseIterable {
  case 천안시
  case 공주시
  case 보령시
  case 아산시
  case 서산시
  case 논산시
  case 계룡시
  case 당진시
  case 금산군
  case 부여군
  case 서천군
  case 청양군
  case 홍성군
  case 예산군
  case 태안군
}

enum GyeongbukSigungu: String, CaseIterable {
  case 포항시
  case 경주시
  case 김천시
  case 안동시
  case 구미시
  case 영주시
  case 영천시
  case 상주시
  case 문경시
  case 경산시
  case 군위군
  case 의성군
  case 청송군
  case 영양군
  case 영덕군
  case 청도군
  case 고령군
  case 성주군
  case 칠곡군
  case 예천군
  case 봉화군
  case 울진군
  case 울릉군
}

enum GyeongnamSigungu: String, CaseIterable {
  case 창원시
  case 진주시
  case 통영시
  case 사천시
  case 김해시
  case 밀양시
  case 거제시
  case 양산시
  case 의령군
  case 함안군
  case 창녕군
  case 고성군
  case 남해군
  case 하동군
  case 산청군
  case 함양군
  case 거창군
  case 합천군
}

enum JeonbukSigungu: String, CaseIterable {
  case 전주시
  case 군산시
  case 익산시
  case 정읍시
  case 남원시
  case 김제시
  case 완주군
  case 진안군
  case 무주군
  case 장수군
  case 임실군
  case 순창군
  case 고창군
  case 부안군
}

enum JeonnamSigungu: String, CaseIterable {
  case 목포시
  case 여수시
  case 순천시
  case 나주시
  case 광양시
  case 담양군
  case 곡성군
  case 구례군
  case 고흥군
  case 보성군
  case 화순군
  case 장흥군
  case 강진군
  case 해남군
  case 영암군
  case 무안군
  case 함평군
  case 영광군
  case 장성군
  case 완도군
  case 진도군
  case 신안군
}

struct Sigungu {
  let rnum: Int?
  let code: String?
  let name: String?
}
