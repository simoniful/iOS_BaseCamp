//
//  CampsiteBasicQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

enum CampsiteQueryType {
  case basic(numberOfRows: Int, pageNo: Int)
  case location(numberOfRows: Int, pageNo: Int, coordinate: Coordinate, radius: Int)
  case keyword(numberOfRows: Int, pageNo: Int, keyword: String)
  case imageList(numberOfRows: Int, pageNo: Int, conteneId: Int)
  
  var query: CampsiteQuery {
    switch self {
    case .basic(let numberOfRows, let pageNo):
      return CampsiteBasicQuery(
        numberOfRows: numberOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.campsite.rawValue
      )
    case .location(let numberOfRows,
                   let pageNo,
                   let coordinate,
                   let radius):
      return CampsiteLocationQuery(
        numberOfRows: numberOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.campsite.rawValue,
        mapX: coordinate.longitude,
        mapY: coordinate.latitude,
        radius: radius
      )
    case .keyword(let numberOfRows,
                  let pageNo,
                  let keyword):
      return CampsiteKeywordQuery(
        numberOfRows: numberOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.campsite.rawValue,
        keyword: keyword
      )
    case .imageList(let numberOfRows,
                    let pageNo,
                    let contentId):
      return CampsiteImageListQuery(
        numberOfRows: numberOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.campsite.rawValue,
        contentId: contentId
      )
    }
  }
}

protocol CampsiteQuery {
  var numberOfRows: Int { get set }
  var pageNo: Int { get set }
  var mobileOS: String { get }
  var moblieApp: String { get }
  var serviceKey: String { get }
}

struct CampsiteBasicQuery: CampsiteQuery {
  var numberOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
}

struct CampsiteLocationQuery: CampsiteQuery {
  var numberOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var mapX: Double
  var mapY: Double
  var radius: Int
}

struct CampsiteKeywordQuery: CampsiteQuery {
  var numberOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var keyword: String
}

struct CampsiteImageListQuery: CampsiteQuery {
  var numberOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
}
