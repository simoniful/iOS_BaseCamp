//
//  TouristInfoRepository.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/27.
//

import Foundation
import RxSwift
import Moya
import RxMoya

enum TouristInfoServiceError: Int, Error {
  case applicationError = 1
  case dbError = 2
  case noDataError = 3
  case httpError = 4
  case serviceTimeoutError = 5
  case invalidParameterError = 10
  case noMandatoryParameterError = 11
  case noOpenAPIServiceError = 12
  case serviceAccessDeniedError = 20
  case temporarilyDisabledError = 21
  case limitedNumberOfServiceRequestsExceedsError = 22
  case serviceKeyisNotRegisteredError = 30
  case deadlineHasExpiredError = 31
  case unregisteredIPError = 32
  case unsignedCallError = 33
  case unknownError = 99
  
  var description: String { self.errorDescription }
}

extension TouristInfoServiceError {
  var errorDescription: String {
    switch self {
    case .applicationError:
      return "1: APPLICATION_ERROR"
    case .dbError:
      return "2: DB_ERROR"
    case .noDataError:
      return "3: NODATA_ERROR"
    case .httpError:
      return "4: HTTP_ERROR"
    case .serviceTimeoutError:
      return "5: SERVICETIMEOUT_ERROR"
    case .invalidParameterError:
      return "10: INVALID_REQUEST_PARAMETER_ERROR"
    case .noMandatoryParameterError:
      return "11: NO_MANDATORY_REQUEST_PARAMETERS_ERROR"
    case .noOpenAPIServiceError:
      return "12: NO_OPENAPI_SERVICE_ERROR"
    case .serviceAccessDeniedError:
      return "20: SERVICE_ACCESS_DENIED_ERROR"
    case .temporarilyDisabledError:
      return "21: TEMPORARILY_DISABLE_THE_SERVICEKEY_ERROR"
    case .limitedNumberOfServiceRequestsExceedsError:
      return "22: LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR"
    case .serviceKeyisNotRegisteredError:
      return "30: SERVICE_KEY_IS_NOT_REGISTERED_ERROR"
    case .deadlineHasExpiredError:
      return "31: DEADLINE_HAS_EXPIRED_ERROR"
    case .unregisteredIPError:
      return "32: UNREGISTERED_IP_ERROR"
    case .unsignedCallError:
      return "33: UNSIGNED_CALL_ERROR"
    case .unknownError:
      return "99: UNKNOWN_ERROR"
    }
  }
}

final class TouristInfoRepository: TouristInfoRepositoryInterface {
  func requestTouristInfoList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[TouristInfo], TouristInfoServiceError>> {
    let requestDTO = TouristInfoRequestDTO(touristInfoQueryType: touristInfoQueryType)
    var target: MultiTarget
    switch touristInfoQueryType {
    case .region:
      target = MultiTarget(TouristInfoTarget.getTouristInfoListByRegion(parameters: requestDTO.toDictionary))
    case .location:
      target = MultiTarget(TouristInfoTarget.getTouristInfoListByLocation(parameters: requestDTO.toDictionary))
    case .keyword:
      target = MultiTarget(TouristInfoTarget.getTouristInfoListByKeyword(parameters: requestDTO.toDictionary))
    case .festival:
      target = MultiTarget(TouristInfoTarget.getFestival(parameters: requestDTO.toDictionary))
    default:
      target = MultiTarget(TouristInfoTarget.getTouristInfoListByLocation(parameters: requestDTO.toDictionary))
    }
    
    return provider.rx.request(target)
      .filterSuccessfulStatusCodes()
      .flatMap { response -> Single<Result<[TouristInfo], TouristInfoServiceError>> in
        let responseDTO = try response.map(TouristInfoResponseDTO.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      }
      .catch { error in
        return Single.just(Result.failure(.unknownError))
      }
  }
  
  func requestTouristInfoCommon(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>> {
    let requestDTO = TouristInfoRequestDTO(touristInfoQueryType: touristInfoQueryType)
    return provider.rx.request(
      MultiTarget(TouristInfoTarget.getTouristInfo(parameters: requestDTO.toDictionary))
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>> in
      let responseDTO = try response.map(TouristInfoCommonResponseDTO.self)
      return Single.just(Result.success(responseDTO.toDomain()))
    }
    .catch { error in
      return Single.just(Result.failure(.unknownError))
    }
    
  }
  
  func requestTouristInfoIntro(touristInfoQueryType: TouristInfoQueryType, contentType: TouristInfoContentType) -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>> {
    let requestDTO = TouristInfoRequestDTO(touristInfoQueryType: touristInfoQueryType)
    return provider.rx.request(
      MultiTarget(TouristInfoTarget.getTouristInfoIntro(parameters: requestDTO.toDictionary))
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>> in
      // 함수 분리
      switch contentType {
      case .touristSpot:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_SpotItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      case .cultureFacilities:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_CultureItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      case .festival:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_FestivalItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      case .leisure:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_LeisureItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      case .shoppingSpot:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_ShoppingItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      case .restaurant:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_RestaurantItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      }
    }
    .catch { error in
      return Single.just(Result.failure(.unknownError))
    }
  }
  
  
  func requestTouristInfoImageList(campsiteQueryType: CampsiteQueryType) -> Single<Result<[String], TouristInfoServiceError>> {
    <#code#>
  }
  
  func requestTouristInfoRegionCode(campsiteQueryType: CampsiteQueryType) -> Single<Result<[Sigungu], TouristInfoServiceError>> {
    
  }
}
