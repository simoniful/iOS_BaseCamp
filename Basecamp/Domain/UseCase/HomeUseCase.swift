//
//  HomeUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeUseCase {
  private let userDefaults = UserDefaults.standard
  
  private let realmRepository: RealmRepositoryInterface
  private let campsiteRepository: CampsiteRepositoryInterface
  private let touristInfoRepository: TouristInfoRepositoryInterface
  
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
  
  func getTouristInfoValue(_ result: Result<[TouristInfo], TouristInfoServiceError>) -> [TouristInfo]? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func getTouristInfoError(_ result: Result<[TouristInfo], TouristInfoServiceError>) -> String? {
    guard case .failure(let error) = result else {
      return nil
    }
    return error.localizedDescription
  }
  
  // Realm, Campsite, Tourist 데이터가 모두 완료된 후
  func getHomeSectionModel(
    _ realmData: [HomeHeaderItem],
    _ areaData: [HomeAreaItem],
    _ campsiteList: [Campsite],
    _ touristList: [TouristInfo]
  ) -> [HomeSectionModel] {
    var data: [HomeSectionModel] = []
    data.append(.headerSection(items: realmData))
    data.append(.areaSection(header: "어디로 가시나요?", items: areaData))
    data.append(.campsiteSection(header: "글램핑", items: campsiteList))
    data.append(.festivalSection(header: "축제/행사 소식", items: touristList))
    return data
  }
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData() -> [HomeHeaderItem] {
    let likedCampsiteCount = realmRepository.loadCampsite().count
    let completedCampsiteCount = realmRepository.loadReview().count
    
    return [
      HomeHeaderItem(
        completedCampsiteCount: completedCampsiteCount,
        likedCampsiteCount: likedCampsiteCount
      )
    ]
  }
  
  func requestSavefromLocalJson() {
    if userDefaults.bool(forKey: UserDefaultKeyCase.isNotFirstUser) {
      print("이미 저장된 상태")
    } else {
      realmRepository.saveFromLocalJson()
      userDefaults.set(true, forKey: UserDefaultKeyCase.isNotFirstUser)
    }
  }
  
  // MARK: - 지역 정보 매핑
  func requestAreaData() -> [HomeAreaItem] {
    let areaList = Area.allCases.map {
      HomeAreaItem(area: $0)
    }
    return areaList
  }
  
  // MARK: - 고캠핑 레포 연결
  func requestCampsiteList(numOfRows: Int, pageNo: Int) -> Single<Result<[Campsite], CampsiteServiceError>> {
    campsiteRepository.requestCampsiteList(
      campsiteQueryType: .basic(numOfRows: numOfRows, pageNo: pageNo)
    )
  }
  
  func requestCampsiteList(numOfRows: Int, pageNo: Int, keyword: String) -> Single<Result<[Campsite], CampsiteServiceError>> {
    campsiteRepository.requestCampsiteList(
      campsiteQueryType: .keyword(numOfRows: numOfRows, pageNo: pageNo, keyword: keyword)
    )
  }
  
  func requestCampsiteList(numOfRows: Int, pageNo: Int, coordinate: Coordinate, radius: Int) -> Single<Result<[Campsite], CampsiteServiceError>> {
    campsiteRepository.requestCampsiteList(
      campsiteQueryType: .location(
        numOfRows: numOfRows, pageNo: pageNo, coordinate: coordinate, radius: radius
      )
    )
  }
  
  // MARK: - 관광정보 레포 연결
  func requestTouristInfoList(numOfRows: Int, pageNo: Int, areaCode: Area?, sigunguCode: Sigungu?, eventStartDate: Date = Date()) -> Single<Result<[TouristInfo], TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoList(
      touristInfoQueryType: .festival(
        numOfRows: numOfRows, pageNo: pageNo, areaCode: areaCode, sigunguCode: sigunguCode, eventStartDate: eventStartDate)
    )
  }
}
