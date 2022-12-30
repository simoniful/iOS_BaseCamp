//
//  CampsiteBasicQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

enum CampsiteQueryType {
  case basic(numOfRows: Int, pageNo: Int)
  case location(numOfRows: Int, pageNo: Int, coordinate: Coordinate, radius: Int)
  case keyword(numOfRows: Int, pageNo: Int, keyword: String)
  case image(numOfRows: Int, pageNo: Int, conteneId: Int)
  
  var query: CampsiteQuery {
    switch self {
    case .basic(let numOfRows, let pageNo):
      return CampsiteBasicQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.campsite.rawValue
      )
    case .location(let numOfRows,
                   let pageNo,
                   let coordinate,
                   let radius):
      return CampsiteLocationQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.campsite.rawValue,
        coordinate: coordinate,
        radius: radius
      )
    case .keyword(let numOfRows,
                  let pageNo,
                  let keyword):
      return CampsiteKeywordQuery(
        numOfRows: numOfRows,
        pageNo: pageNo,
        mobileOS: "IOS",
        moblieApp: "Basecamp",
        serviceKey: APIKey.campsite.rawValue,
        keyword: keyword
      )
    case .image(let numOfRows,
                    let pageNo,
                    let contentId):
      return CampsiteImageQuery(
        numOfRows: numOfRows,
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
  var numOfRows: Int { get set }
  var pageNo: Int { get set }
  var mobileOS: String { get }
  var moblieApp: String { get }
  var serviceKey: String { get }
}

struct CampsiteBasicQuery: CampsiteQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
}

struct CampsiteLocationQuery: CampsiteQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var coordinate: Coordinate
  var radius: Int
}

struct CampsiteKeywordQuery: CampsiteQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var keyword: String
}

struct CampsiteImageQuery: CampsiteQuery {
  var numOfRows: Int
  var pageNo: Int
  let mobileOS: String
  let moblieApp: String
  let serviceKey: String
  var contentId: Int
}
