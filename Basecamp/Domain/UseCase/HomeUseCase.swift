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
  
  // MARK: - 램 데이터베이스 레포 연결
  func requestRealmData() {
    
  }
  
  // MARK: - 고캠핑 레포 연결
  func requestCampsiteList() {
    
  }
  
  // MARK: - 관광정보 레포 연결
  // home의 경우 페스티벌만 이용 
  func requestTouristInfoList() {
    
  }
}
