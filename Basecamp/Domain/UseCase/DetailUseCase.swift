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
        tel: campsite.tel!,
        isLiked: realmRepository.checkCampsite(campsite: campsite)
      )
    ]
  }
  
  func requestHeaderData(touristInfo: TouristInfo, touristCommon: [TouristInfoCommon], images: [String]) -> [DetailTouristInfoHeaderItem]{
    return [
      DetailTouristInfoHeaderItem(
        imageDataList: images,
        title: touristInfo.title!,
        address: touristInfo.address!,
        tel: touristInfo.tel!,
        homepage: (touristCommon.first?.homepage)!,
        contentId: touristInfo.contentId!,
        contentTypeId: touristInfo.contentTypeId,
        eventStartDate: touristInfo.eventStartDate,
        eventEndDate: touristInfo.eventEndDate,
        overview: (touristCommon.first?.overview)!
      )
    ]
  }
  
  func requestLocationData(campsite: Campsite, weatherData: [WeatherInfo]) -> [DetailLocationItem] {
    return [
      DetailLocationItem(
        mapX: campsite.mapX!,
        mapY: campsite.mapY!,
        address: campsite.addr1!,
        direction: campsite.direction ?? "※ 자세한 위치는 문의처에 문의 바랍니다",
        weatherInfos: weatherData
      )
    ]
  }
  
  func requestLocationData(touristInfo: TouristInfo, weatherData: [WeatherInfo]) -> [DetailLocationItem] {
    return [
      DetailLocationItem(
        mapX: touristInfo.mapX!,
        mapY: touristInfo.mapY!,
        address: touristInfo.address!,
        direction: "※ 자세한 위치는 문의처에 문의 바랍니다",
        weatherInfos: weatherData
      )
    ]
  }
  
  func requestFacilityData(campsite: Campsite) -> [DetailCampsiteFacilityItem] {
    var facArr: [Facility] = []
    let sbrsClArr = campsite.sbrsCl?.components(separatedBy: ",")
    sbrsClArr?.forEach {
      if let enumCase = Facility(rawValue: $0) {
        facArr.append(enumCase)
      }
    }
    let result = facArr.map {
      DetailCampsiteFacilityItem(facility: $0)
    }
    return result
  }
  
  func requsetInfoData(campsite: Campsite) -> [DetailCampsiteInfoItem] {
    return [
      DetailCampsiteInfoItem(
        gnrlSiteCo: campsite.gnrlSiteCo!,
        autoSiteCo: campsite.autoSiteCo!,
        glampSiteCo: campsite.glampSiteCo!,
        caravSiteCo: campsite.caravSiteCo!,
        sbrsEtc: campsite.sbrsEtc!,
        animalCmgCl: campsite.animalCmgCl!,
        glampInnerFclty: campsite.glampInnerFclty!,
        caravInnerFclty: campsite.caravInnerFclty!,
        brazierCl: campsite.brazierCl!,
        extshrCo: campsite.extshrCo!,
        frprvtWrppCo: campsite.frprvtWrppCo!,
        frprvtSandCo: campsite.frprvtSandCo!,
        fireSensorCo: campsite.fireSensorCo!,
        overview: campsite.intro!,
        themaEnvrnCl: campsite.themaEnvrnCl!,
        tooltip: campsite.tooltip!
      )
    ]
  }
  
  func requestIntroData(intro: [TouristInfoIntro], contentType: TouristInfoContentType) -> [any  DetailTouristInfoIntroItem] {
    switch contentType {
    case .touristSpot:
      return [DetailTouristInfoSpotIntroItem(intro: intro.first as! TouristInfoIntroSpot)]
    case .cultureFacilities:
      return [DetailTouristInfoCultureIntroItem(intro: intro.first as! TouristInfoIntroCulture)]
    case .festival:
      return [DetailTouristInfoFestivalIntroItem(intro: intro.first as! TouristInfoIntroFestival)]
    case .leisure:
      return [DetailTouristInfoLeisureIntroItem(intro: intro.first as! TouristInfoIntroLeisure)]
    case .accommodation:
      return [DetailTouristInfoAccommodationIntroItem(intro: intro.first as! TouristInfoIntroAccommodation)]
    case .shoppingSpot:
      return [DetailTouristInfoShoppingIntroItem(intro: intro.first as! TouristInfoIntroShopping)]
    case .restaurant:
      return [DetailTouristInfoRestaurantIntroItem(intro: intro.first as! TouristInfoIntroRestaurant)]
    }
  }
  
  func requestSocialData(youtubeData: [YoutubeInfo], naverBlogData: [NaverBlogInfo]) ->  [DetailSocialItem] {
    let mediaInfoList: [SocialMediaInfo] = youtubeData + naverBlogData
    let result = mediaInfoList.map {
      DetailSocialItem(socialMediaInfo: $0)
    }
    return result
  }
  
  func requestAroundData(campsite: Campsite) -> [DetailAroundItem] {
    return [
      DetailAroundItem(
        mapX: campsite.mapX!,
        mapY: campsite.mapY!,
        radius: "10000"
      )
    ]
  }
  
  func requestAroundData(touristInfo: TouristInfo) -> [DetailAroundItem] {
    return [
      DetailAroundItem(
        mapX: touristInfo.mapX!,
        mapY: touristInfo.mapY!,
        radius: "20000"
      )
    ]
  }
  
  func requestImageData(images: [String]) -> [DetailImageItem] {
    return images.map {
      DetailImageItem(image: $0)
    }
  }
  
  func getDetailCampsiteSectionModel(
    _ headerData: [DetailCampsiteHeaderItem],
    _ locationData: [DetailLocationItem],
    _ facilityData: [DetailCampsiteFacilityItem],
    _ infoData: [DetailCampsiteInfoItem],
    _ socialData: [DetailSocialItem],
    _ aroundData: [DetailAroundItem],
    _ imageData: [DetailImageItem]
  ) -> [DetailCampsiteSectionModel] {
    var data: [DetailCampsiteSectionModel] = []
    data.append(.headerSection(items: headerData))
    data.append(.locationSection(header: "위치/주변 정보", items: locationData))
    data.append(.facilitySection(header: "시설 정보", items: facilityData))
    data.append(.infoSection(items: infoData))
    data.append(.socialSection(header: "SNS", items: socialData))
    data.append(.aroundSection(header: "주변에 갈만한 곳", items: aroundData))
    data.append(.imageSection(header: "캠핑장 사진", items: imageData))
    return data
  }
  
  func getDetailTouristInfoSectionModel(
    _ headerData: [DetailTouristInfoHeaderItem],
    _ locationData: [DetailLocationItem],
    _ introData: [any DetailTouristInfoIntroItem],
    _ socialData: [DetailSocialItem],
    _ aroundData: [DetailAroundItem],
    _ imageData: [DetailImageItem]
  ) -> [DetailTouristInfoSectionModel] {
    var data: [DetailTouristInfoSectionModel] = []
    data.append(.headerSection(items: headerData))
    data.append(.locationSection(header: "위치/주변 정보", items: locationData))
    data.append(.introSection(header: "세부 정보", items: introData))
    data.append(.socialSection(header: "SNS", items: socialData))
    data.append(.aroundSection(header: "주변에 갈만한 곳", items: aroundData))
    data.append(.imageSection(header: "사진", items: imageData))
    return data
  }
  
  // MARK: - 고캠핑 레포 연결
  func requestCampsiteImageList(numOfRows: Int, pageNo: Int, contentId: String) -> Single<Result<[String], CampsiteServiceError>> {
    campsiteRepository.requestCampsiteImageList(
      campsiteQueryType: .image(numOfRows: numOfRows, pageNo: pageNo, contentId: contentId)
    )
  }
  
  // MARK: - 날씨 레포 연결
  func requestWeatherList(lat: Double, lon: Double) -> Single<Result<[WeatherInfo], WeatherServiceError>> {
    weatherRepository.requestWeatherList(weatherQueryType: .basic(lat: lat, lon: lon))
  }
  
  // MARK: - 네이버 블로그 검색 레포 연결
  func requestNaverBlogInfoList(keyword: String, display: Int) -> Single<Result<[NaverBlogInfo], NaverBlogServiceError>> {
    naverBlogRepository.requestNaverBlogInfoList(naverBlogQueryType: .basic(keyword: keyword, display: display))
  }
  
  // MARK: - 유튜브 검색 레포 연결
  func requestYoutubeInfoList(keyword: String, maxResults: Int) -> Single<Result<[YoutubeInfo], YoutubeServiceError>> {
    youtubeRepository.requestYoutubeInfoList(youtubeQueryType: .basic(keyword: keyword, maxResults: maxResults))
  }
  
  // MARK: - 관광정보 레포 연결
  func requestTouristInfoList(numOfRows: Int, pageNo: Int, contentTypeId: TouristInfoContentType, coordinate: Coordinate, radius: Int) -> Single<Result<TouristInfoData, TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoList(touristInfoQueryType: .location(numOfRows: numOfRows, pageNo: pageNo, contentTypeId: contentTypeId, coordinate: coordinate, radius: radius))
  }
  
  func requestTouristInfoImageList(contentId: Int) -> Single<Result<[String], TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoImageList(touristInfoQueryType: .image(contentId: contentId))
  }
  
  func requestTouristInfoCommon(contentId: Int, contentTypeId: TouristInfoContentType) -> Single<Result<[TouristInfoCommon], TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoCommon(touristInfoQueryType: .commonInfo(contentId: contentId, contentTypeId: contentTypeId))
  }
  
  func requestTouristInfoIntro(contentId: Int, contentTypeId: TouristInfoContentType) -> Single<Result<[TouristInfoIntro], TouristInfoServiceError>> {
    touristInfoRepository.requestTouristInfoIntro(touristInfoQueryType: .introInfo(contentId: contentId, contentTypeId: contentTypeId), contentType: contentTypeId)
  }
}
