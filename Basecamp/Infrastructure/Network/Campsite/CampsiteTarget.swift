//
//  CampsiteTarget.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import Moya

typealias DictionaryType = [String: Any]

//private func JSONResponseDataFormatter(_ data: Data) -> String {
//    do {
//        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
//        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
//        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
//    } catch {
//        return String(data: data, encoding: .utf8) ?? ""
//    }
//}
//
//public func url(_ route: TargetType) -> String {
//    route.baseURL.appendingPathComponent(route.path).absoluteString
//}
//
//private extension String {
//    var urlEscaped: String {
//        self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//    }
//}

enum CampsiteTarget {
  case getCampsite(parameters: DictionaryType)
  case getCampsiteByLocation(parameters: DictionaryType)
  case getCampsiteByKeyword(parameters: DictionaryType)
  case getCampsiteImageList(parameters: DictionaryType)
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
    case .getCampsite(let parameters),
         .getCampsiteByLocation(let parameters),
         .getCampsiteByKeyword(let parameters),
         .getCampsiteImageList(let parameters):
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
    return ["Content-Type": "application/json"]
  }
}


