//
//  TouristInfoTarget.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import Moya

enum TouristInfoTarget {
  case getServiceCateogryCode(parameters: DictionaryType)
  case getTouristInfoListByArea(parameters: DictionaryType)
  case getTouristInfoListByLocation(parameters: DictionaryType)
  case getTouristInfoListByKeyword(parameters: DictionaryType)
  case getFestival(parameters: DictionaryType)
  case getTouristInfo(parameters: DictionaryType)
  case getTouristInfoIntro(parameters: DictionaryType)
  case getTouristInfoImage(parameters: DictionaryType)
  case getAreaCode(parameters: DictionaryType)
}

extension TouristInfoTarget: TargetType {
  var baseURL: URL {
    guard let url = URL(string: TouristInfoAPIConstant.environment.rawValue) else {
        fatalError("Fatal error - invalid tourist API url")
    }
    return url
  }
  
  var path: String {
    switch self {
    case .getServiceCateogryCode:
      return "/categoryCode"
    case .getTouristInfoListByArea:
      return "/areaBasedList"
    case .getTouristInfoListByLocation:
      return "/locationBasedList"
    case .getTouristInfoListByKeyword:
      return "/searchKeyword"
    case .getFestival:
      return "/searchFestival"
    case .getTouristInfo:
      return "/detailCommon"
    case .getTouristInfoIntro:
      return "/detailIntro"
    case .getTouristInfoImage:
      return "/detailImage"
    case .getAreaCode:
      return "/areaCode"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getServiceCateogryCode,
         .getTouristInfoListByArea,
         .getTouristInfoListByLocation,
         .getTouristInfoListByKeyword,
         .getFestival,
         .getTouristInfo,
         .getTouristInfoIntro,
         .getTouristInfoImage,
         .getAreaCode:
      return .get
    }
  }
  
  var sampleData: Data {
    return stubData(self)
  }
  
  var task: Task {
    switch self {
    case .getServiceCateogryCode(let parameters),
         .getTouristInfoListByArea(let parameters),
         .getTouristInfoListByLocation(let parameters),
         .getTouristInfoListByKeyword(let parameters),
         .getFestival(let parameters),
         .getTouristInfo(let parameters),
         .getTouristInfoIntro(let parameters),
         .getTouristInfoImage(let parameters),
         .getAreaCode(let parameters):
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
