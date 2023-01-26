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
  case getCampsite(parameters: DictionaryType)
  case getCampsiteByLocation(parameters: DictionaryType)
  case getCampsiteByKeyword(parameters: DictionaryType)
  case getCampsiteImage(parameters: DictionaryType)
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
    case .getCampsiteImage:
      return "/imageList"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getCampsite,
         .getCampsiteByLocation,
         .getCampsiteByKeyword,
         .getCampsiteImage:
      return .get
    }
  }
  
  var sampleData: Data {
    return stubData(self)
  }
  
  var task: Task {
    switch self {
    case .getCampsite(let parameters),
         .getCampsiteByLocation(let parameters),
         .getCampsiteByKeyword(let parameters),
         .getCampsiteImage(let parameters):
      return .requestParameters(
        parameters: parameters,
        encoding: URLEncoding.default
      )
    }
  }
  
  var validationType: ValidationType {
      return .customCodes([200])
  }
  
  var headers: [String : String]? {
    // text/html도 가능
    return ["Content-Type": "text/html"]
  }
}


