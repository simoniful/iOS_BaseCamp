//
//  TouristInfoQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

enum TouristInfoQueryType {
  case area(numOfRows: Int, pageNo: Int, contentTypeId: TouristInfoContentType, areaCode: Area, sigunguCode: Sigungu)
  case location(numOfRows: Int, pageNo: Int, contentTypeId: TouristInfoContentType, coordinate: Coordinate, radius: Int)
  case keyword(numOfRows: Int, pageNo: Int, contentTypeId: TouristInfoContentType, areaCode: Area, sigunguCode: Sigungu, keyword: String)
  case festival(numOfRows: Int, pageNo: Int, areaCode: Area, sigunguCode: Sigungu, eventStartDate: Date)
  case commonInfo(contentId: Int, contentTypeId: TouristInfoContentType)
  case introInfo(contentId: Int, contentTypeId: TouristInfoContentType)
  case image(contentId: Int)
  case areaCode(numOfRows: Int, pageNo: Int, areaCode: Area)
  
  var query: TouristInfoQuery {
    switch self {
    case .area(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode):
      return TouristInfoAreaQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentTypeId: contentTypeId,
        areaCode: areaCode,
        sigunguCode: sigunguCode
      )
    case .location(let numOfRows, let pageNo, let contentTypeId, let coordinate, let radius):
      return TouristInfoLocationQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentTypeId: contentTypeId,
        coordinate: coordinate,
        radius: radius
      )
    case .keyword(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode, let keyword):
       return TouristInfoKeywordQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentTypeId: contentTypeId,
        areaCode: areaCode,
        sigunguCode: sigunguCode,
        keyword: keyword
       )
    case .festival(let numOfRows, let pageNo, let areaCode, let sigunguCode, let eventStartDate):
      return TouristInfoFestivalQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        areaCode: areaCode,
        sigunguCode: sigunguCode,
        eventStartDate: eventStartDate
      )
    case .commonInfo(let contentId, let contentTypeId):
      return TouristInfoCommonQuery(
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentId: contentId,
        contentTypeId: contentTypeId
      )
    case .introInfo(let contentId, let contentTypeId):
      return TouristInfoIntroQuery(
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentId: contentId,
        contentTypeId: contentTypeId
      )
    case .image(let contentId):
      return TouristInfoImageQuery(
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentId: contentId
      )
    case .areaCode(let numOfRows, let pageNo, let areaCode):
      return TouristInfoAreaCodeQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        areaCode: areaCode
      )
    }
  }
}

protocol TouristInfoQuery {
  var mobileOS: String { get }
  var moblieApp: String { get }
  var serviceKey: String { get }
}

struct TouristInfoAreaQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: TouristInfoContentType
  let areaCode: Area
  let sigunguCode: Sigungu
}

struct TouristInfoLocationQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: TouristInfoContentType
  var coordinate: Coordinate
  var radius: Int
}

struct TouristInfoKeywordQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: TouristInfoContentType
  var areaCode: Area
  var sigunguCode: Sigungu
  var keyword: String
}

struct TouristInfoFestivalQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var areaCode: Area
  var sigunguCode: Sigungu
  var eventStartDate: Date = Date()
  var eventEndDate: Date {
    return eventStartDate.addMonths(numberOfMonths: 1)
  }
}

struct TouristInfoCommonQuery: TouristInfoQuery {
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
  var contentTypeId: TouristInfoContentType
}

struct TouristInfoIntroQuery: TouristInfoQuery {
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
  var contentTypeId: TouristInfoContentType
}

struct TouristInfoImageQuery: TouristInfoQuery {
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
}

struct TouristInfoAreaCodeQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var areaCode: Area
}
