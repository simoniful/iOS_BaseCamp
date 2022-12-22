//
//  NaverBlogTarget.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation
import Moya

//let naverBlogTargetProvider = MoyaProvider<NaverBlogTarget>(
//  plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
//)

enum NaverBlogTarget {
  case getNaverBlog(parameters: DictionaryType)
}

extension NaverBlogTarget: TargetType {
  var baseURL: URL {
    guard let url = URL(string: NaverBlogAPIConstant.environment.rawValue) else {
        fatalError("Fatal error - invalid naver blog API url")
    }
    return url
  }
  
  var path: String {
    switch self {
    case .getNaverBlog(_):
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case.getNaverBlog(_):
      return .get
    }
  }
  
  var sampleData: Data {
    return stubData(self)
  }
  
  var task: Task {
    switch self {
    case .getNaverBlog(let parameters):
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
    return [
      "X-Naver-Client-Id": APIKey.naverBlogId.rawValue,
      "X-Naver-Client-Secret": APIKey.naverBlogSecret.rawValue
    ]
  }
}


