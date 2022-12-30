//
//  CampsiteRepository.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation
import Moya
import RxMoya
import RxSwift

// 외부 에러 코드 / 내부 에러 코드 분리
enum CampsiteServiceError: Int, Error {
  case applicationError = 1
  case httpError = 4
  case noOpenAPIServiceError = 12
  case serviceAccessDeniedError = 20
  case limitedNumberOfServiceRequestsExceedsError = 22
  case serviceKeyisNotRegisteredError = 30
  case deadlineHasExpiredError = 31
  case unregisteredIPError = 32
  case unknownError = 99
  
  var description: String { self.errorDescription }
}

extension CampsiteServiceError {
  var errorDescription: String {
    switch self {
    case .applicationError:
      return "1: APPLICATION_ERROR"
    case .httpError:
      return "4: HTTP_ERROR"
    case .noOpenAPIServiceError:
      return "12: NO_OPENAPI_SERVICE_ERROR"
    case .serviceAccessDeniedError:
      return "20: SERVICE_ACCESS_DENIED_ERROR  "
    case .limitedNumberOfServiceRequestsExceedsError:
      return "22: LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR"
    case .serviceKeyisNotRegisteredError:
      return "30: SERVICE_KEY_IS_NOT_REGISTERED_ERROR"
    case .deadlineHasExpiredError:
      return "31: DEADLINE_HAS_EXPIRED_ERROR"
    case .unregisteredIPError:
      return "32: UNREGISTERED_IP_ERROR"
    default:
      return "99: UNKNOWN_ERROR"
    }
  }
}

final class CampsiteRepository: CampsiteRepositoryInterface {
  func requestCampsiteList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[Campsite], CampsiteServiceError>> {
    var target: MultiTarget
    switch campsiteQueryType {
    case .basic:
      let query = campsiteQueryType.query as! CampsiteBasicQuery
      let requestDTO = CampsiteBasicRequestDTO(query: query)
      target = MultiTarget(CampsiteTarget.getCampsite(parameters: requestDTO.toDictionary))
    case .location:
      let query = campsiteQueryType.query as! CampsiteLocationQuery
      let requestDTO = CampsiteLocationRequestDTO(query: query)
      target = MultiTarget(CampsiteTarget.getCampsiteByLocation(parameters: requestDTO.toDictionary))
    case .keyword:
      let query = campsiteQueryType.query as! CampsiteKeywordQuery
      let requestDTO = CampsiteKeywordRequestDTO(query: query)
      target = MultiTarget(CampsiteTarget.getCampsiteByKeyword(parameters: requestDTO.toDictionary))
    case .image:
      return Single.just(Result.failure(.applicationError))
    }
    
    return provider.rx.request(
      MultiTarget(target)
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[Campsite], CampsiteServiceError>> in
      let responseDTO = try response.map(CampsiteResponseDTO.self)
      return Single.just(Result.success(responseDTO.toDomain()))
    }
    .catch { error in
      return Single.just(Result.failure(.applicationError))
    }
  }
  
  func requestCampsiteImageList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[String], CampsiteServiceError>> {
    let query = campsiteQueryType.query as! CampsiteImageQuery
    let requestDTO = CampsiteImageRequestDTO(query: query)
    return provider.rx.request(
      MultiTarget(CampsiteTarget.getCampsiteImage(parameters: requestDTO.toDictionary))
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[String], CampsiteServiceError>> in
      let responseDTO = try response.map(CampsiteImageResponseDTO.self)
      return Single.just(Result.success(responseDTO.toDomain()))
    }
    .catch { error in
      return Single.just(Result.failure(.applicationError))
    }
  }
}


