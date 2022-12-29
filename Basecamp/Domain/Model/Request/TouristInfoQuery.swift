//
//  TouristInfoQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

enum TouristInfoQueryType {
  case categoryCode(numOfRows: Int, pageNo: Int, contentTypeId: Int, cat1: String, cat2: String, cat3: String)
  case region(numOfRows: Int, pageNo: Int, contentTypeId: Int, areaCode: Int, sigunguCode: Int, cat1: String, cat2: String, cat3: String)
  case location(numOfRows: Int, pageNo: Int, contentTypeId: Int, coordinate: Coordinate, radius: Int)
  case keyword(numOfRows: Int, pageNo: Int, contentTypeId: Int, areaCode: Int, sigunguCode: Int, cat1: String, cat2: String, cat3: String, keyword: String)
  case festival(numOfRows: Int, pageNo: Int, areaCode: Int, sigunguCode: Int, eventStartDate: String, eventEndDate: String)
  case stay(numOfRows: Int, pageNo: Int, areaCode: Int, sigunguCode: Int)
  case commonInfo(contentId: Int, contentTypeId: Int)
  case introInfo(contentId: Int, contentTypeId: Int)
  case detailInfo(contentId: Int, contentTypeId: Int)
  case imageList(contentId: Int)
  case regionCode(numOfRows: Int, pageNo: Int, areaCode: Int)
  
  var query: TouristInfoQuery {
    switch self {
    case .categoryCode(let numOfRows, let pageNo, let contentTypeId, let cat1, let cat2, let cat3):
      return TouristInfoCategoryCodeQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentTypeId: contentTypeId,
        cat1: cat1,
        cat2: cat2,
        cat3: cat3
      )
    case .region(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode, let cat1, let cat2, let cat3):
      return TouristInfoRegionQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentTypeId: contentTypeId,
        areaCode: areaCode,
        sigunguCode: sigunguCode,
        cat1: cat1,
        cat2: cat2,
        cat3: cat3
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
    case .keyword(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode, let cat1, let cat2, let cat3, let keyword):
       return TouristInfoKeywordQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentTypeId: contentTypeId,
        areaCode: areaCode,
        sigunguCode: sigunguCode,
        cat1: cat1,
        cat2: cat2,
        cat3: cat3,
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
    case .stay(let numOfRows, let pageNo, let areaCode, let sigunguCode):
      return TouristInfoStayQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        areaCode: areaCode,
        sigunguCode: sigunguCode
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
    case .detailInfo(let contentId, let contentTypeId):
      return TouristInfoDetailQuery(
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.touristInfo.rawValue,
        contentId: contentId,
        contentTypeId: contentTypeId
      )
    case .imageList(let contentId):
      return TouristInfoimageListQuery(
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

struct TouristInfoCategoryCodeQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: Int
  let cat1: String
  let cat2: String
  let cat3: String
}

struct TouristInfoRegionQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: Int
  let areaCode: Int
  let sigunguCode: Int
  let cat1: String
  let cat2: String
  let cat3: String
}

struct TouristInfoLocationQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  let contentTypeId: Int
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
  let contentTypeId: Int
  var areaCode: Int
  var sigunguCode: Int
  let cat1: String
  let cat2: String
  let cat3: String
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

struct TouristInfoStayQuery: TouristInfoQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var areaCode: Int
  var sigunguCode: Int
}

struct TouristInfoCommonQuery: TouristInfoQuery {
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
  var contentTypeId: Int
}

struct TouristInfoDetailQuery: TouristInfoQuery {
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
  var contentTypeId: Int
}

struct TouristInfoIntroQuery: TouristInfoQuery {
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
  var contentTypeId: Int
}

struct TouristInfoimageListQuery: TouristInfoQuery {
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
