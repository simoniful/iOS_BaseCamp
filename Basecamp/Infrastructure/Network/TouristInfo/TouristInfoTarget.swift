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
  case getTouristInfoListByRegion(parameters: DictionaryType)
  case getTouristInfoListByLocation(parameters: DictionaryType)
  case getTouristInfoListByKeyword(parameters: DictionaryType)
  case getFestival(parameters: DictionaryType)
  case getStay(parameters: DictionaryType)
  case getTouristInfo(parameters: DictionaryType)
  case getTouristInfoIntro(parameters: DictionaryType)
  case getTouristInfoDetail(parameters: DictionaryType)
  case getTouristIngoImageList(parameters: DictionaryType)
  case getRegionCode(parameters: DictionaryType)
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
    case .getTouristInfoListByRegion:
      return "/areaBasedList"
    case .getTouristInfoListByLocation:
      return "/locationBasedList"
    case .getTouristInfoListByKeyword:
      return "/searchKeyword"
    case .getFestival:
      return "/searchFestival"
    case .getStay:
      return "/searchStay"
    case .getTouristInfo:
      return "/detailCommon"
    case .getTouristInfoIntro:
      return "/detailIntro"
    case .getTouristInfoDetail:
      return "/detailInfo"
    case .getTouristIngoImageList:
      return "/detailImage"
    case .getRegionCode:
      return "/areaCode"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getServiceCateogryCode,
         .getTouristInfoListByRegion,
         .getTouristInfoListByLocation,
         .getTouristInfoListByKeyword,
         .getFestival,
         .getStay,
         .getTouristInfo,
         .getTouristInfoIntro,
         .getTouristInfoDetail,
         .getTouristIngoImageList,
         .getRegionCode:
      return .get
    }
  }
  
  var sampleData: Data {
    return stubData(self)
  }
  
  var task: Task {
    switch self {
    case .getServiceCateogryCode(let parameters),
         .getTouristInfoListByRegion(let parameters),
         .getTouristInfoListByLocation(let parameters),
         .getTouristInfoListByKeyword(let parameters),
         .getFestival(let parameters),
         .getStay(let parameters),
         .getTouristInfo(let parameters),
         .getTouristInfoIntro(let parameters),
         .getTouristInfoDetail(let parameters),
         .getTouristIngoImageList(let parameters),
         .getRegionCode(let parameters):
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
