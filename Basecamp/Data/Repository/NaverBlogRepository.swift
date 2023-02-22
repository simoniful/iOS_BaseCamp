//
//  NaverBlogRepository.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import Moya

enum NaverBlogServiceError: String, Error {
  case incorrectQueryRequest = "SE01"
  case invalidDisplayValue = "SE02"
  case malformedEncoding = "SE06"
  case invalidSearchApi = "SE05"
  case systemError = "SE99"
  
  var description: String { self.errorDescription }
}

extension NaverBlogServiceError {
  var errorDescription: String {
    switch self {
    case .incorrectQueryRequest:
      return "400: SE01 / 잘못된 쿼리요청입니다"
    case .invalidDisplayValue:
      return "400: SE02 / 부적절한 display 값입니다"
    case .malformedEncoding:
      return "400: SE06 / 잘못된 형식의 인코딩입니다"
    case .invalidSearchApi:
      return "404: SE05 / 존재하지 않는 검색 api 입니다"
    case .systemError:
      return "500: SE99 / 시스템 에러"
    }
  }
}

final class NaverBlogRepository: NaverBlogRepositoryInterface {
  func requestNaverBlogInfoList(naverBlogQueryType: NaverBlogQueryType) -> Single<Result<[NaverBlogInfo], NaverBlogServiceError>> {
    switch naverBlogQueryType {
    case .basic(let keyword, _):
      let query = naverBlogQueryType.query
      let requestDTO = NaverBlogRequestDTO(query: query)
      let target = MultiTarget(NaverBlogTarget.getNaverBlog(parameters: requestDTO.toDictionary))
      
      return provider.rx.request(target)
        .filterSuccessfulStatusCodes()
        .flatMap { response -> Single<Result<[NaverBlogInfo], NaverBlogServiceError>> in
          let responseDTO = try response.map(NaverBlogResponseDTO.self)
          return Single.just(Result.success(responseDTO.toDomain(keyword: keyword)))
        }
        .catch { error in
          return Single.just(Result.failure(.systemError))
        }
    }
  }
  
  
}
