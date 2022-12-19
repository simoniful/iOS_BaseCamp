//
//  CampsiteTarget.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import Moya

typealias DictionaryType = [String: Any]

enum CampsiteTarget {
  case getCampsite
  case getCampsiteByLocation(coordinate: Coordinate, radius: Int)
  case getCampsiteByKeyword(keyword: String)
  case getCampsiteImageList(contentId: String)
}

extension CampsiteTarget: TargetType {
  var baseURL: URL {
    guard let url = URL(string: CampsiteAPIConstant.environment.rawValue) else {
        fatalError("Fatal error - invalid campsite API url")
    }
    return url
  }
  
  var path: String {
    switch self {
    case .getCampsite:
      return "/basedList"
    case .getCampsiteByLocation:
      return "/locationBasedList"
    case .getCampsiteByKeyword:
      return "/searchList"
    case .getCampsiteImageList:
      return "/imageList"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getCampsite,
         .getCampsiteByLocation,
         .getCampsiteByKeyword,
         .getCampsiteImageList:
      return .get
    }
  }
  
  var sampleData: Data {
    return stubData(self)
  }
  
  var task: Task {
    switch self {
    case .getCampsite:
      return .requestParameters(
        parameters: [
          "numOfRows": "20",
          "pageNo": "1",
          "MobileOS": "IOS",
          "MobileApp": "BaseCamping",
          "serviceKey": APIKey.campsite,
          "_type": "json"
        ],
        encoding: URLEncoding.default
      )
    case .getCampsiteByLocation(let coordinate, let radius):
      return .requestParameters(
        parameters: [
          "numOfRows": "20",
          "pageNo": "1",
          "MobileOS": "IOS",
          "MobileApp": "BaseCamping",
          "serviceKey": APIKey.campsite,
          "mapX": coordinate.longitude,
          "mapY": coordinate.latitude,
          "radius": radius,
          "_type": "json"
        ],
        encoding: URLEncoding.default
      )
    case .getCampsiteByKeyword(let keyword):
      return .requestParameters(
        parameters: [
          "numOfRows": "20",
          "pageNo": "1",
          "MobileOS": "IOS",
          "MobileApp": "BaseCamping",
          "serviceKey": APIKey.campsite,
          "keyword": keyword,
          "_type": "json"
        ],
        encoding: URLEncoding.default
      )
    case .getCampsiteImageList(let contentId):
      return .requestParameters(
        parameters: [
          "numOfRows": "20",
          "pageNo": "1",
          "MobileOS": "IOS",
          "MobileApp": "BaseCamping",
          "serviceKey": APIKey.campsite,
          "contentId": contentId,
          "_type": "json"
        ],
        encoding: URLEncoding.default
      )
    }
  }
  
  var validationType: ValidationType {
      return .customCodes([200])
  }
  
  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}


