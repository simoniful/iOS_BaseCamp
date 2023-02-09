//
//  TouristInfoContentType.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

enum TouristInfoContentType: Int, CaseIterable, Codable {
  case touristSpot = 12
  case cultureFacilities = 14
  case festival = 15
  case tourCourse = 25
  case leisure = 28
  case accommodation = 32
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
    case .accommodation:
      return "숙박"
    case .shoppingSpot:
      return "쇼핑"
    case .restaurant:
      return "맛집"
    case .tourCourse:
      return "여행코스"
    }
  }
  
  var introDic: [String: String] {
    switch self {
    case .touristSpot:
      return [
        "accomcount": "수용인원",
        "chkcreditcard": "신용카드가능",
        "chkpet": "애완동물동반가능",
        "expagerange": "체험가능 연령",
        "expguide": "체험안내",
        "infocenter": "문의 및 안내",
        "parking": "주차시설",
        "restdate": "쉬는날",
        "useseason": "이용시기",
        "usetime": "이용시간",
        "opendate": "개장일"
      ]
    case .cultureFacilities:
      return [
        "accomcountculture": "수용인원",
        "chkcreditcardculture": "신용카드가능",
        "chkpetculture": "애완동물동반가능",
        "discountinfo": "할인정보",
        "infocenterculture": "문의 및 안내",
        "parkingculture": "주차시설",
        "parkingfee": "주차요금",
        "restdateculture": "쉬는날",
        "usefee": "이용요금",
        "usetimeculture": "이용시간",
        "spendtime": "관람 소요시간"
      ]
    case .festival:
      return [
        "agelimit": "관람 가능연령",
        "bookingplace": "예매처",
        "discountinfofestival": "할인정보",
        "eventEndDate": "행사 종료일",
        "eventhomepage": "행사 홈페이지",
        "eventplace": "행사 장소",
        "eventStartDate": "행사 시작일",
        "placeinfo": "행사장 위치안내",
        "playtime": "공연시간",
        "program": "행사 프로그램",
        "spendtimefestival": "관람 소요시간",
        "sponsor1": "주최자 정보",
        "sponsor1tel": "주최자 연락처",
        "sponsor2": "주관사 정보",
        "sponsor2tel": "주관사 연락처",
        "subevent": "부대행사",
        "usetimefestival": "이용요금"
      ]
    case .leisure:
      return [
        "accomcountleports": "수용인원",
        "chkcreditcardleports": "신용카드가능",
        "chkpetleports": "애완동물동반가능",
        "expagerangeleports": "체험 가능연령",
        "infocenterleports": "문의 및 안내",
        "openperiod": "개장기간",
        "parkingfeeleports": "주차요금",
        "parkingleports": "주차시설",
        "reservation": "예약안내",
        "restdateleports": "쉬는날",
        "usefeeleports": "입장료",
        "usetimeleports": "이용시간"
      ]
    case .accommodation:
      return [
        "checkintime": "입실 시간",
        "checkouttime": "퇴실 시간",
        "chkcooking": "객실내 취사",
        "foodplace": "식음료장",
        "infocenterlodging": "문의 및 안내",
        "parkinglodging": "주차시설",
        "pickup": "픽업 서비스",
        "roomcount": "객실수",
        "reservationlodging": "예약안내",
        "reservationurl": "예약안내 홈페이지",
        "subfacility": "부대시설",
        "refundregulation": "환불규정"
      ]
    case .shoppingSpot:
      return [
        "chkcreditcardshopping": "신용카드가능",
        "chkpetshopping": "애완동물동반가능",
        "culturecenter": "문화센터 바로가기",
        "fairday": "장서는 날",
        "infocentershopping": "문의 및 안내",
        "opendateshopping": "개장일",
        "opentime": "영업시간",
        "parkingshopping": "주차시설",
        "restdateshopping": "쉬는날",
        "restroom": "화장실",
        "saleitem": "판매 품목",
        "saleitemcost": "판매 품목별 가격",
        "scaleshopping": "규모",
        "shopguide": "매장안내"
      ]
    case .restaurant:
      return [
        "chkcreditcardfood": "신용카드가능",
        "discountinfofood": "할인정보",
        "firstmenu": "대표 메뉴",
        "infocenterfood": "문의 및 안내",
        "kidsfacility": "어린이 놀이방",
        "opentimefood": "영업시간",
        "packing": "포장 가능",
        "parkingfood": "주차시설",
        "reservationfood": "예약안내",
        "restdatefood": "쉬는날",
        "seat": "좌석수",
        "smoking": "금연/흡연",
        "treatmenu": "취급 메뉴"
      ]
    case .tourCourse:
      return [
        "distance": "코스 총거리",
        "infocentertourcourse": "문의 및 안내",
        "schedule": "코스 일정",
        "taketime": "코스 총 소요시간",
        "theme": "코스 테마"
      ]
    }
  }
}
