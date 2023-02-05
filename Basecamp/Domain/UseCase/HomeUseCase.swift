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
  
  private let searchKeyword = ["오토캠핑"].randomElement()
  private let theme = Experience.allCases.randomElement()
  
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
  
  func getHomeSectionModel(
    _ realmData: [HomeHeaderItem],
    _ areaData: [HomeAreaItem],
    _ campsiteKeywordList: [Campsite],
    _ campsiteThemeList: [Campsite],
    _ touristList: [TouristInfo]
  ) -> [HomeSectionModel] {
    var data: [HomeSectionModel] = []
    data.append(.headerSection(items: realmData))
    data.append(.areaSection(header: "어디로 가시나요?", items: areaData))
    data.append(.campsiteKeywordSection(header: searchKeyword!, items: campsiteKeywordList))
    data.append(.campsiteThemeSection(header: theme!.rawValue + " 가능한 캠핑장", items: campsiteThemeList))
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
    // 실제 버전 구분에 대한 플래그 작성 필요 - 날짜
    if userDefaults.bool(forKey: UserDefaultKeyCase.isNotFirstUser) {
      print("realm DB OK")
    } else {
      realmRepository.saveFromLocalJson()
      userDefaults.set(true, forKey: UserDefaultKeyCase.isNotFirstUser)
    }
  }
  
  func requestCampsiteThemeList() -> [Campsite] {
    let data = realmRepository.loadCampsite(query: theme!.realmQuery)
    return data
  }
  
  // MARK: - 지역 정보 매핑
  func requestAreaData() -> [HomeAreaItem] {
    let areaList = Area.allCases.map {
      HomeAreaItem(area: $0)
    }
    return areaList
  }
  
  // MARK: - 고캠핑 레포 연결
  func requestCampsiteKeywordList(numOfRows: Int, pageNo: Int) -> Single<Result<[Campsite], CampsiteServiceError>> {
    campsiteRepository.requestCampsiteList(
      campsiteQueryType: .keyword(numOfRows: numOfRows, pageNo: pageNo, keyword: searchKeyword!)
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
  func requestTouristInfoList(numOfRows: Int, pageNo: Int, areaCode: Area?, sigunguCode: Sigungu?, eventStartDate: Date = Date()) -> Single<Result<TouristInfoData, TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoList(
      touristInfoQueryType: .festival(
        numOfRows: numOfRows, pageNo: pageNo, areaCode: areaCode, sigunguCode: sigunguCode, eventStartDate: eventStartDate)
    )
  }
}
