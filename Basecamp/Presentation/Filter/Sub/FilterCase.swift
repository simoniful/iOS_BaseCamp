//
//  FilterCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/14.
//

import Foundation


enum FilterCase {
  case area(Area?)
  case environment([Environment]?, [Experience]?)
  case rule([CampType]?, [ReservationType]?)
  case facility([BasicFacility]?, [SanitaryFacility]?, [SportsFacility]?)
  case pet([PetEnterType]?, [PetSize]?)
  
  var title: String {
    switch self {
    case .area:
      return "위치"
    case .environment:
      return "환경"
    case .rule:
      return "이용규정"
    case .facility:
      return "시설/프로그램"
    case .pet:
      return "반려동물"
    }
  }
}

enum Environment: String, CaseIterable {
  case mountain = "산"
  case forest = "숲"
  case valley = "계곡"
  case lake = "호수"
  case river = "강"
  case ocean = "해변"
  case island = "섬"
  case city = "도심"
}


enum Experience: String, CaseIterable {
  case waterplay = "물놀이"
  case seaBathing = "해수욕"
  case foreshore = "갯벌체험"
  case fishing = "낚시"
  case hiking = "등산"
}

enum CampType: String, CaseIterable {
  case glamping = "글램핑"
  case caravan = "카라반"
  case auto = "자동차야영장"
  case normal = "일반야영장"
}

enum ReservationType: String, CaseIterable {
  case onlineOntime = "온라인실시간예약"
  case tel = "전화"
  case onlineWaiting = "온라인예약대기"
  case offline = "현장"
}

enum BasicFacility: String, CaseIterable {
  case wifi = "와이파이"
  case electric = "전기"
  case convenience = "편의점"
  case cafe = "카페"
  case restuarant = "식당"
  case refrigerator = "냉장고"
  case microwave = "전자레인지"
}

enum SanitaryFacility: String, CaseIterable {
  case shower = "샤워장"
  case hotwater = "온수"
  case washingmachine = "세탁"
  case wood = "장작판매"
}

enum SportsFacility: String, CaseIterable {
  case trampoline = "트렘폴린"
  case waterpool = "물놀이장"
  case playground = "놀이터"
  case exerciseFclty = "운동시설"
  case trail = "산책로"
  case playfield = "운동장"
}

enum PetEnterType: String, CaseIterable {
  case accompanied = "가능"
  case notAllowed = "불가"
}

enum PetSize: String, CaseIterable {
  case small = "소형견"
  case large = "대형견"
}
