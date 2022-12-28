//
//  TouristInfoQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

enum TouristInfoQueryType {
  case categoryCode(numOfRows: Int, pageNo: Int, contentTypeId: Int, cat1: String, cat2: String, cat3: String)
  case region(numOfRows: Int, pageNo: Int, contentTypeId: Int, areaCode: Int, sigunguCode: Int, cat1: String, cat2: String, cat3: String, modifiedtime: String)
  case location(numOfRows: Int, pageNo: Int, coordinate: Coordinate, radius: Int)
  case keyword(numOfRows: Int, pageNo: Int, contentTypeId: Int, keyword: String)
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
      <#code#>
    case .region(let numOfRows, let pageNo, let contentTypeId, let areaCode, let sigunguCode, let cat1, let cat2, let cat3, let modifiedtime):
      <#code#>
    case .location(let numOfRows, let pageNo, let coordinate, let radius):
      <#code#>
    case .keyword(let numOfRows, let pageNo, let contentTypeId, let keyword):
      <#code#>
    case .festival(let numOfRows, let pageNo, let areaCode, let sigunguCode, let eventStartDate, let eventEndDate):
      <#code#>
    case .stay(let numOfRows, let pageNo, let areaCode, let sigunguCode):
      <#code#>
    case .commonInfo(let contentId, let contentTypeId):
      <#code#>
    case .introInfo(let contentId, let contentTypeId):
      <#code#>
    case .detailInfo(let contentId, let contentTypeId):
      <#code#>
    case .imageList(let contentId):
      <#code#>
    case .regionCode(let numOfRows, let pageNo, let areaCode):
      <#code#>
    }
  }
}

protocol TouristInfoQuery {}

struct CategoryCodeQuery: TouristInfoQuery {
  
}

struct TouristInfoRegionQuery: TouristInfoQuery {
  
}

struct TouristInfoLocationQuery: TouristInfoQuery {
  
}

struct TouristInfoKeywordQuery: TouristInfoQuery {
  
}

struct TouristInfoFestivalQuery: TouristInfoQuery {
  
}

struct TouristInfoStayQuery: TouristInfoQuery {
  
}

struct TouristInfoCommonQuery: TouristInfoQuery {
  
}

struct TouristInfoDetailQuery: TouristInfoQuery {
  
}

struct TouristInfoIntroQuery: TouristInfoQuery {
  
}

struct TouristInfoimageListQuery: TouristInfoQuery {
  
}

struct TouristInfoRegionCodeQuery: TouristInfoQuery {
  
}
