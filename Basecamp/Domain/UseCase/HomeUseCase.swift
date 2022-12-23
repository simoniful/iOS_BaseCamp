//
//  HomeUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import RxSwift
import RxCocoa

// like Model
final class HomeUseCase {
  private let realmRepository: RealmRepositoryInterface
  private let campsiteRepository: CampsiteRepositoryInterface
  private let touristInfoRepository: TouristInfoRepositoryInterface
  
  var successCampsiteListSignal = PublishRelay<[Campsite]>()
  var unKnownErrorSignal = PublishRelay<Void>()
  
  init(
    realmRepository: RealmRepositoryInterface,
    campsiteRepository: CampsiteRepositoryInterface,
    touristInfoRepository: TouristInfoRepositoryInterface
  ) {
    self.realmRepository = realmRepository
    self.campsiteRepository = campsiteRepository
    self.touristInfoRepository = touristInfoRepository
  }
  
  func getCampsiteValue(_ result: Result<[Campsite], CampsiteServiceError>) -> [Campsite]? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func getCampsiteError(_ result: Result<[Campsite], CampsiteServiceError>) -> String? {
    guard case .failure(let error) = result else {
      return nil
    }
    return error.localizedDescription
  }
  
  // Realm, Campsite, Tourist 데이터가 모두 완료된 후
  func getHomeSectionModel(
//    _ realmData: ,
//    _ regionData: ,
    _ firstCampsiteList: [Campsite],
    _ secondCampsiteList: [Campsite]
//    _ touristList: [TourlistInfo]
  
  ) -> [HomeSectionModel] {
    
    
    return []
  }
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData() {
    
    
  }
  
  // MARK: - 고캠핑 레포 연결
  // 파라미터 구성 및 viewModel 연결
  func requestCampsiteList(numOfRows: Int, pageNo: Int) -> Single<Result<[Campsite], CampsiteServiceError>> {
    campsiteRepository.requestCampsite(
      campsiteQueryType: .basic(numOfRows: numOfRows, pageNo: pageNo)
    )
  }
  
  func requestCampsiteList(numOfRows: Int, pageNo: Int, keyword: String) -> Single<Result<[Campsite], CampsiteServiceError>> {
    campsiteRepository.requestCampsite(
      campsiteQueryType: .keyword(numOfRows: numOfRows, pageNo: pageNo, keyword: keyword)
    )
  }
  
  func requestCampsiteList(numOfRows: Int, pageNo: Int, coordinate: Coordinate, radius: Int) -> Single<Result<[Campsite], CampsiteServiceError>> {
    campsiteRepository.requestCampsite(
      campsiteQueryType: .location(numOfRows: numOfRows, pageNo: pageNo, coordinate: coordinate, radius: radius)
    )
  }
  
  // MARK: - 관광정보 레포 연결
  // home의 경우 페스티벌만 이용 
  func requestTouristInfoList() {
    
  }
}
