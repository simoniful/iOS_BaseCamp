//
//  DetailUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailUseCase {
  private let campsiteRepository: CampsiteRepositoryInterface
  private let realmRepository: RealmRepositoryInterface
  private let touristInfoRepository: TouristInfoRepositoryInterface
  private let weatherRepository: WeatherRepositoryInterface
  private let naverBlogRepository: NaverBlogRepositoryInterface
  private let youtubeRepository: YoutubeRepositoryInterface
  
  init(
    campsiteRepository: CampsiteRepositoryInterface,
    realmRepository: RealmRepositoryInterface,
    touristInfoRepository: TouristInfoRepositoryInterface,
    weatherRepository: WeatherRepositoryInterface,
    naverBlogRepository: NaverBlogRepositoryInterface,
    youtubeRepository: YoutubeRepositoryInterface
  ) {
    self.campsiteRepository = campsiteRepository
    self.realmRepository = realmRepository
    self.touristInfoRepository = touristInfoRepository
    self.weatherRepository = weatherRepository
    self.naverBlogRepository = naverBlogRepository
    self.youtubeRepository = youtubeRepository
  }
  
  func getCampsiteImageValue(_ result: Result<[String], CampsiteServiceError>) -> [String]? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func getCampsiteImageError(_ result: Result<[String], CampsiteServiceError>) -> String? {
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
  
  func requestHeaderData(campsite: Campsite, images: [String]) -> [DetailCampsiteHeaderItem] {
    return [
      DetailCampsiteHeaderItem(
        imageDataList: images,
        name: campsite.facltNm!,
        address: campsite.addr1!,
        lctCl: campsite.lctCl!,
        facltDivNm: campsite.facltDivNm!,
        induty: campsite.induty!,
        operPDCl: campsite.operPDCl!,
        operDeCl: campsite.operDeCl!,
        homepage: campsite.homepage!,
        resveCl: campsite.resveCl!,
        posblFcltyCl: campsite.posblFcltyCl!,
        tel: campsite.tel!
      )
    ]
  }
  
  func getDetailCampsiteSectionModel(
    _ headerData: [DetailCampsiteHeaderItem],
    _ locationData: [DetailLocationItem],
    _ facilityData: [DetailCampsiteFacilityItem],
    _ infoData: [DetailCampsiteInfoItem],
    _ imageData: [DetailImageItem]
  ) -> [DetailCampsiteSectionModel] {
    var data: [DetailCampsiteSectionModel] = []
    data.append(.headerSection(items: headerData))
    data.append(.locationSection(header: "위치/주변 정보", items: locationData))
    data.append(.facilitySection(header: "시설 정보", items: facilityData))
    data.append(.infoSection(items: infoData))
    data.append(.imageSection(header: "캠핑장 사진", items: imageData))
    return data
  }
  
  // MARK: - 고캠핑 레포 연결
  func requestCampsiteImageList(numOfRows: Int, pageNo: Int, contentId: String) -> Single<Result<[String], CampsiteServiceError>> {
    campsiteRepository.requestCampsiteImageList(
      campsiteQueryType: .image(numOfRows: numOfRows, pageNo: pageNo, contentId: contentId)
    )
  }
  
  
}
