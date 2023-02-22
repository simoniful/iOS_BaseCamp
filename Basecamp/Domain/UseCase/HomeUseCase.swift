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
  private let touristInfoRepository: TouristInfoRepositoryInterface
  
  private let searchKeyword = CampType.allCases.randomElement()
  private let theme = Experience.allCases.randomElement()
  
  init(
    realmRepository: RealmRepositoryInterface,
    touristInfoRepository: TouristInfoRepositoryInterface
  ) {
    self.realmRepository = realmRepository
    self.touristInfoRepository = touristInfoRepository
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
    data.append(.campsiteKeywordSection(header: searchKeyword!.rawValue, items: campsiteKeywordList))
    data.append(.campsiteThemeSection(header: theme!.rawValue + " 가능한 캠핑장", items: campsiteThemeList))
    data.append(.festivalSection(header: "축제/행사 소식", items: touristList.shuffled()))
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
  
  func requestCampsiteTypeList() -> [Campsite] {
    let data = realmRepository.loadCampsite(query: searchKeyword!.realmQuery)
    return data.shuffled()
  }
  
  func requestCampsiteThemeList() -> [Campsite] {
    let data = realmRepository.loadCampsite(query: theme!.realmQuery)
    return data.shuffled()
  }
  
  // MARK: - 지역 정보 매핑
  func requestAreaData() -> [HomeAreaItem] {
    let areaList = Area.allCases.map {
      HomeAreaItem(area: $0)
    }
    return areaList
  }
  
  // MARK: - 관광정보 레포 연결
  func requestTouristInfoList(numOfRows: Int, pageNo: Int, areaCode: Area?, sigunguCode: Sigungu?, eventStartDate: Date = Date()) -> Single<Result<TouristInfoData, TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoList(
      touristInfoQueryType: .festival(
        numOfRows: numOfRows, pageNo: pageNo, areaCode: areaCode, sigunguCode: sigunguCode, eventStartDate: eventStartDate)
    )
  }
}
