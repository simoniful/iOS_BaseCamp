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
  func requestTouristInfoList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<TouristInfoData, TouristInfoServiceError>> {
    var target: MultiTarget
    switch touristInfoQueryType {
    case .area:
      let query = touristInfoQueryType.query as! TouristInfoAreaQuery
      let requestDTO = TouristInfoAreaRequestDTO(query: query)
      target = MultiTarget(TouristInfoTarget.getTouristInfoListByArea(parameters: requestDTO.toDictionary))
    case .location:
      let query = touristInfoQueryType.query as! TouristInfoLocationQuery
      let requestDTO = TouristInfoLocationRequestDTO(query: query)
      target = MultiTarget(TouristInfoTarget.getTouristInfoListByLocation(parameters: requestDTO.toDictionary))
    case .keyword:
      let query = touristInfoQueryType.query as! TouristInfoKeywordQuery
      let requestDTO = TouristInfoKeywordRequestDTO(query: query)
      target = MultiTarget(TouristInfoTarget.getTouristInfoListByKeyword(parameters: requestDTO.toDictionary))
    case .festival:
      let query = touristInfoQueryType.query as! TouristInfoFestivalQuery
      let requestDTO = TouristInfoFestivalRequestDTO(query: query)
      target = MultiTarget(TouristInfoTarget.getFestival(parameters: requestDTO.toDictionary))
    case .commonInfo, .introInfo, .image, .areaCode:
      return Single.just(Result.failure(.unknownError))
    }
    return provider.rx.request(target)
      .filterSuccessfulStatusCodes()
      .flatMap { response -> Single<Result<TouristInfoData, TouristInfoServiceError>> in
        let a = response.data
        do {
          let json = String(data: a, encoding: .utf8)
          print(json, "투어리스트 패칭 에러 문자열")
        } catch {
          print("errorMsg")
        }
        let responseDTO = try response.map(TouristInfoResponseDTO.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      }
      .retry(3)
      .catch { error in
        print(error, "투어리스트 패칭 에러")
        return Single.just(Result.failure(.unknownError))
      }
  }
  
  func requestTouristInfoCommon(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>> {
    let query = touristInfoQueryType.query as! TouristInfoCommonQuery
    let requestDTO = TouristInfoCommonRequestDTO(query: query)
    return provider.rx.request(
      MultiTarget(TouristInfoTarget.getTouristInfo(parameters: requestDTO.toDictionary))
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>> in
      let responseDTO = try response.map(TouristInfoCommonResponseDTO.self)
      return Single.just(Result.success(responseDTO.toDomain()))
    }
    .retry(3)
    .catch { error in
      print(error, "투어리스트 커먼 패칭 에러")
      return Single.just(Result.failure(.unknownError))
    }
  }
  
  func requestTouristInfoIntro(touristInfoQueryType: TouristInfoQueryType, contentType: TouristInfoContentType) -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>> {
    let query = touristInfoQueryType.query as! TouristInfoIntroQuery
    let requestDTO = TouristInfoIntroRequestDTO(query: query)
    return provider.rx.request(
      MultiTarget(TouristInfoTarget.getTouristInfoIntro(parameters: requestDTO.toDictionary))
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>> in
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
      case .accommodation:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_AccommodationItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      case .shoppingSpot:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_ShoppingItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
      case .restaurant:
        let responseDTO = try response.map(TouristInfoIntroResponseDTO<TouristInfoIntroResponseDTO_RestaurantItem>.self)
        return Single.just(Result.success(responseDTO.toDomain()))
   
      }
    }
    .retry(3)
    .catch { error in
      print(error, "투어리스트 인트로 패칭 에러")
      return Single.just(Result.failure(.unknownError))
    }
  }
  
  
  func requestTouristInfoImageList(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[String], TouristInfoServiceError>> {
    let query = touristInfoQueryType.query as! TouristInfoImageQuery
    let requestDTO = TouristInfoImageRequestDTO(query: query)
    return provider.rx.request(
      MultiTarget(TouristInfoTarget.getTouristInfoImage(parameters: requestDTO.toDictionary))
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[String], TouristInfoServiceError>> in
      let responseDTO = try response.map(TouristInfoImageResponseDTO.self)
      return Single.just(Result.success(responseDTO.toDomain()))
    }
    .retry(3)
    .catchAndReturn(.success([]))
  }
  
  func requestTouristInfoAreaCode(touristInfoQueryType: TouristInfoQueryType) -> Single<Result<[Sigungu], TouristInfoServiceError>> {
    let query = touristInfoQueryType.query as! TouristInfoAreaCodeQuery
    let requestDTO = TouristInfoAreaCodeRequestDTO(query: query)
    return provider.rx.request(
      MultiTarget(TouristInfoTarget.getAreaCode(parameters: requestDTO.toDictionary))
    )
    .filterSuccessfulStatusCodes()
    .flatMap { response -> Single<Result<[Sigungu], TouristInfoServiceError>> in
      let responseDTO = try response.map(TouristInfoAreaCodeResponseDTO.self)
      return Single.just(Result.success(responseDTO.toDomain()))
    }
    .retry(3)
    .catch { error in
      print(error, "투어리스트 아리아 코드 패칭 에러")
      return Single.just(Result.failure(.unknownError))
    }
  }
}
