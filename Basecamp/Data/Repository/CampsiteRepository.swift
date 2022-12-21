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
  let provider: MoyaProvider<MultiTarget>
  
  init() { provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])}
}

extension CampsiteRepository {
  func requestCampsite(campsiteQueryType: CampsiteQueryType) -> Single<Result<[Campsite], CampsiteServiceError>> {
    let requestDTO = CampsiteRequestDTO(campsiteQueryType: campsiteQueryType)
    return provider.rx.request(
      MultiTarget(CampsiteTarget.getCampsite(parameters: requestDTO.toDictionary))
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
}


