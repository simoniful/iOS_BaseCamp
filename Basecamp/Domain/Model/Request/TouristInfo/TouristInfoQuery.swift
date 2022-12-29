//
//  TouristInfoQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

enum TouristInfoQueryType {
  case region(numOfRows: Int, pageNo: Int, contentTypeId: TouristInfoContentType, areaCode: Int, sigunguCode: Int)
  case location(numOfRows: Int, pageNo: Int, contentTypeId: TouristInfoContentType, coordinate: Coordinate, radius: Int)
  case keyword(numOfRows: Int, pageNo: Int, contentTypeId: TouristInfoContentType, areaCode: Int, sigunguCode: Int, keyword: String)
  case festival(numOfRows: Int, pageNo: Int, areaCode: Int, sigunguCode: Int, eventStartDate: String, eventEndDate: String)
  case commonInfo(contentId: Int, contentTypeId: TouristInfoContentType)
  case introInfo(contentId: Int, contentTypeId: TouristInfoContentType)
  case imageList(contentId: Int)
  case regionCode(numOfRows: Int, pageNo: Int, areaCode: Int)
  
  var query: TouristInfoQuery {
    switch self {
    case .region(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode):
      return TouristInfoRegionQuery(
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
        mapX: coordinate.longitude,
        mapY: coordinate.latitude,
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
    case .festival(let numOfRows, let pageNo, let areaCode, let sigunguCode, let eventStartDate, let eventEndDate):
      return TouristInfoFestivalQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        areaCode: areaCode,
        sigunguCode: sigunguCode,
        eventStartDate: eventStartDate,
        eventEndDate: eventEndDate
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
    case .imageList(let contentId):
      return TouristInfoImageListQuery(
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentId: contentId
      )
    case .regionCode(let numOfRows, let pageNo, let areaCode):
      return TouristInfoRegionCodeQuery(
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

struct TouristInfoRegionQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: TouristInfoContentType
  let areaCode: Int
  let sigunguCode: Int
}

struct TouristInfoLocationQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: TouristInfoContentType
  var mapX: Double
  var mapY: Double
  var radius: Int
}

struct TouristInfoKeywordQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: TouristInfoContentType
  var areaCode: Int
  var sigunguCode: Int
  var keyword: String
}

struct TouristInfoFestivalQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var areaCode: Int
  var sigunguCode: Int
  var eventStartDate: String
  var eventEndDate: String
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

struct TouristInfoImageListQuery: TouristInfoQuery {
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
}

struct TouristInfoRegionCodeQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var areaCode: Int
}
