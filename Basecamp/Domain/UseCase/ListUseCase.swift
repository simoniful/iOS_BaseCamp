//
//  ListUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ListUseCase {
  
  private let realmRepository: RealmRepositoryInterface
  private let touristInfoRepository: TouristInfoRepositoryInterface
  
  init(touristInfoRepository: TouristInfoRepositoryInterface, realmRepository: RealmRepositoryInterface) {
    self.touristInfoRepository = touristInfoRepository
    self.realmRepository = realmRepository
  }
  
  func getValue<T>(_ result: Result<[T], some Error>) -> [T]? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func getError<T>(_ result: Result<[T], some Error>) -> String? {
    guard case .failure(let error) = result else {
      return nil
    }
    return error.localizedDescription
  }
  
  func getTouristInfoValue(_ result: Result<TouristInfoData, TouristInfoServiceError>) -> TouristInfoData? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func getTouristInfoError(_ result: Result<TouristInfoData, TouristInfoServiceError>) -> String? {
    guard case .failure(let error) = result else {
      return nil
    }
    return error.localizedDescription
  }
  
  // MARK: - 관광정보 레포 연결
  func requestTouristInfoAreaCode(numOfRows: Int, pageNo: Int, areaCode: Area) -> Single<Result<[Sigungu], TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoAreaCode(
      touristInfoQueryType: .areaCode(
        numOfRows: numOfRows, pageNo: pageNo, areaCode: areaCode
      )
    )
  }
  
  func requestTouristInfoList(numOfRows: Int, pageNo: Int, areaCode: Area?, sigunguCode: Sigungu?, eventStartDate: Date = Date(), type: TouristInfoContentType?) -> Single<Result<TouristInfoData, TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoList(
      touristInfoQueryType: .area(
        numOfRows: numOfRows, pageNo: pageNo,
        contentTypeId: type, areaCode: areaCode,
        sigunguCode: sigunguCode
      )
    )
  }
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData(area: Area?, sigungu: Sigungu?) -> [Campsite] {
    let data = realmRepository.loadCampsite(area: area, sigungu: sigungu)
    return data
  }
}
