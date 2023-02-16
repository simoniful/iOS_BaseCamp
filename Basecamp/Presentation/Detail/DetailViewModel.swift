//
//  DetailViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare

// 스타일에 따른 다른 데이터 소스/레이아웃 구성
enum DetailStyle {
  case campsite(data: Campsite)
  case touristInfo(data: TouristInfo)
}

final class DetailViewModel: ViewModel {
  weak var coordinator: DetailCoordinator?
  private let detailUseCase: DetailUseCase
  public let style: DetailStyle
  
  init(coordinator: DetailCoordinator?, detailUseCase: DetailUseCase, style: DetailStyle) {
    self.coordinator = coordinator
    self.detailUseCase = detailUseCase
    self.style = style
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
    let isAutorizedLocation: Signal<Bool>
    let didSelectItemAt: Signal<(DetailItem, IndexPath)>
    let shareButtonDidTapped: Signal<Void>
  }
  
  struct Output {
    let campsiteData: Driver<[DetailCampsiteSectionModel]>
    let touristInfoData: Driver<[DetailTouristInfoSectionModel]>
    let confirmAuthorizedLocation: Signal<Void>
    let updateLocationAction: Signal<Void>
    let unAutorizedLocationAlert: Signal<(String, String)>
    let noUrlDataAlert: Signal<(String, String, String)>
    let callAlert: Signal<(String, String, String)>
  }
  
  lazy var aroundTabmanViewModel = DetailAroundTabmanViewModel()
  lazy var campsiteHeaderViewModel = DetailCampsiteHeaderCellViewModel(
    likeButtonDidTapped: PublishRelay<Void>(),
    visitButtonDidTapped: PublishRelay<Void>(),
    reservationButtonDidTapped: PublishRelay<Void>(),
    callButtonDidTapped: PublishRelay<Void>(),
    pagerViewDidTapped: PublishRelay<String>(),
    isLiked: BehaviorRelay<Bool>(value: false)
  )
  lazy var touristHeaderViewModel = DetailTouristInfoHeaderCellViewModel(
    reservationButtonDidTapped: PublishRelay<Void>(),
    callButtonDidTapped: PublishRelay<Void>(),
    pagerViewDidTapped: PublishRelay<String>()
  )
  
  private let campsiteData = PublishRelay<[DetailCampsiteSectionModel]>()
  private let touristInfoData = PublishRelay<[DetailTouristInfoSectionModel]>()
  private let confirmAuthorizedLocation = PublishRelay<Void>()
  private let updateLocationAction = PublishRelay<Void>()
  private let unAutorizedLocationAlert = PublishRelay<(String, String)>()
  private let noUrlDataAlert = PublishRelay<(String, String, String)>()
  private let callAlert = PublishRelay<(String, String, String)>()
  private let isAutorizedLocation = BehaviorRelay<Bool>(value: false)
  public let headerAction = PublishRelay<HeaderCellAction>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    switch style {
    case .campsite(let campsite):
      campsiteHeaderViewModel.isLiked.accept(campsite.isLiked)
      
      // MARK: - Header Data
      let campsiteImageResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestCampsiteImageList(
            numOfRows: 30, pageNo: 1, contentId: campsite.contentID
          )
        }
      
      let campsiteImageValue = campsiteImageResult
        .compactMap { [weak self] data -> [String]? in
          self?.detailUseCase.getValue(data)
        }
      
      let campsiteImageError = campsiteImageResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let headerValue = campsiteImageValue
        .withUnretained(self)
        .map { (owner, images) -> [DetailCampsiteHeaderItem] in
          owner.detailUseCase.requestHeaderData(campsite: campsite, images: images)
        }
      
      // MARK: - Location Data
      let weatherResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestWeatherList(
            lat: Double(campsite.mapY)!,
            lon: Double(campsite.mapX)!
          )
        }
      
      let weatherValue = weatherResult
        .compactMap { [weak self] data -> [WeatherInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let weatherError = weatherResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let locationValue = weatherValue
        .withUnretained(self)
        .map { (owner, weatherData) -> [DetailLocationItem] in
          owner.detailUseCase.requestLocationData(campsite: campsite, weatherData: weatherData)
        }
      
      // MARK: - Facility Data
      let facilityValue = input.viewWillAppear
        .compactMap { [weak self] _ in
          self?.detailUseCase.requestFacilityData(campsite: campsite)
        }
      
      // MARK: - Info Data
      let infoValue = input.viewWillAppear
        .compactMap { [weak self] _ in
          self?.detailUseCase.requsetInfoData(campsite: campsite)
        }
      
      // MARK: - Social Data
      let naverBlogResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestNaverBlogInfoList(keyword: campsite.facltNm ,display: 3)
        }
      
      let youtubeResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestYoutubeInfoList(keyword: campsite.facltNm, maxResults: 3)
        }
      
      let naverBlogValue = naverBlogResult
        .compactMap { [weak self] data -> [NaverBlogInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let naverBlogError = naverBlogResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let youtubeValue = youtubeResult
        .compactMap { [weak self] data -> [YoutubeInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let youtubeError = youtubeResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let socialValue = Observable.combineLatest(naverBlogValue, youtubeValue)
        .withUnretained(self)
        .compactMap{ (owner, social) -> [DetailSocialItem] in
          let (naverBlog, youtube) = social
          return owner.detailUseCase.requestSocialData(youtubeData: youtube, naverBlogData: naverBlog)
        }
      
      // MARK: - Around Data
      let aroundValue = input.viewWillAppear
        .compactMap { [weak self] _ in
          self?.detailUseCase.requestAroundData(campsite: campsite)
        }
      
      // MARK: - Image Data
      let imageValue = campsiteImageValue
        .compactMap { [weak self] data in
          self?.detailUseCase.requestImageData(images: data)
        }
      
      Observable.combineLatest(
        headerValue, locationValue,
        facilityValue, infoValue,
        socialValue, aroundValue,
        imageValue
      )
      .withUnretained(self)
      .compactMap { (owner, values) -> [DetailCampsiteSectionModel] in
        let (header, location, facility, info, social, around, image) = values
        return owner.detailUseCase.getDetailCampsiteSectionModel(header, location, facility, info, social, around, image)
      }
      .bind(to: campsiteData)
      .disposed(by: disposeBag)
      
      // MARK: - Around Tabman Data
      let touristResult = aroundTabmanViewModel.detailAroundTabmanSubViewModel.viewWillAppearWithContentType
        .withUnretained(self)
        .flatMapLatest { (owner, eventWithType) in
          let (_, contentType) = eventWithType
          return owner.detailUseCase.requestTouristInfoList(
            numOfRows: 20, pageNo: 1,
            contentTypeId: contentType,
            coordinate: Coordinate(
              latitude: Double(campsite.mapY)!,
              longitude: Double(campsite.mapX)!
            ),
            radius: 10000
          )
        }
      
      let touristValue = touristResult
        .compactMap { [weak self] data -> TouristInfoData? in
          self?.detailUseCase.getTouristInfoValue(data)
        }
      
      let touristError = touristResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getTouristInfoError(data)
        }
      
      touristValue
        .bind(to: aroundTabmanViewModel.detailAroundTabmanSubViewModel.resultCellData)
        .disposed(by: disposeBag)
      
      aroundTabmanViewModel.detailAroundTabmanSubViewModel.didSelectItemAt
        .subscribe { [weak self] (touristInfo, indexPath) in
          guard let self = self else { return }
          self.coordinator?.navigateToFlowDetail(with: .touristInfo(data: touristInfo))
        }
        .disposed(by: disposeBag)
      
      // MARK: - CLLocation Control
      input.isAutorizedLocation
        .emit(onNext: { [weak self] isEnable in
          guard let self = self else { return }
          if isEnable {
            self.updateLocationAction.accept(())
          } else {
            self.unAutorizedLocationAlert.accept(("위치 서비스 사용 불가", "아이폰 설정으로 이동합니다."))
          }
        })
        .disposed(by: disposeBag)
      
      input.isAutorizedLocation
        .emit(to: isAutorizedLocation)
        .disposed(by: disposeBag)
      
      // MARK: - HeaderAction
      campsiteHeaderViewModel.callButtonDidTapped
        .bind { [weak self] _ in
          let tel = campsite.tel
          if tel.isEmpty {
            self?.noUrlDataAlert.accept(("등록된 번호가 없습니다", "검색 엔진으로 이동하여 검색 하시겠습니까?", campsite.facltNm))
          } else {
            self?.callAlert.accept(("해당 번호로 전화를 거시겠습니까?", "📞 " + tel, tel))
          }
        }
        .disposed(by: disposeBag)
      
      campsiteHeaderViewModel.reservationButtonDidTapped
        .bind { [weak self] _ in
          guard campsite.homepage != "" else {
            self?.noUrlDataAlert.accept(("등록된 홈페이지가 없습니다", "검색 엔진으로 이동하여 검색 하시겠습니까?", campsite.facltNm))
            return
          }
          guard let urlStr = campsite.homepage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
          guard let url = URL(string: urlStr) else { return }
          guard UIApplication.shared.canOpenURL(url) else { return }
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        .disposed(by: disposeBag)
      
      campsiteHeaderViewModel.visitButtonDidTapped
        .bind { [weak self] _ in
          guard let self = self else { return }
          self.coordinator?.showDateSelectModal(with: campsite)
        }
        .disposed(by: disposeBag)
      
      campsiteHeaderViewModel.likeButtonDidTapped
        .withUnretained(self)
        .bind { (owner, _) in
          let old = owner.campsiteHeaderViewModel.isLiked.value
          print(old)
          let new = !old
          owner.campsiteHeaderViewModel.isLiked.accept(new)
          owner.detailUseCase.requestSaveLikeState(campsite: campsite)
        }
        .disposed(by: disposeBag)
      
      campsiteHeaderViewModel.pagerViewDidTapped
        .subscribe { [weak self] url in
          self?.coordinator?.navigateToFlowZoom(with: url)
        }
        .disposed(by: disposeBag)
      
      
      input.didSelectItemAt
        .withUnretained(self)
        .emit { (owner, itemWithIndex) in
          let (item, indexPath) = itemWithIndex
          switch indexPath.section {
          case 4:
            guard let item = item as? DetailSocialItem else { return }
            owner.coordinator?.navigateToFlowWeb(with: item.socialMediaInfo)
          case 6:
            guard let item = item as? DetailImageItem else { return }
            owner.coordinator?.navigateToFlowZoom(with: item.image)
          default:
            break
          }
        }
        .disposed(by: disposeBag)
      
      input.shareButtonDidTapped
        .emit { [weak self] _ in
          if ShareApi.isKakaoTalkSharingAvailable(){
            let appLink = Link(iosExecutionParams: ["second": "vvv"])
            
            let button = Button(title: "앱에서 보기", link: appLink)
            let imageUrl = campsite.firstImageURL.isEmpty ? "https://images2.imgbox.com/3d/34/7xkF2x0U_o.png" : campsite.firstImageURL
            var description: String = ""
            description += campsite.addr1.isEmpty ? "" : "주소: " + campsite.addr1 + "\n"
            description += campsite.tel.isEmpty ? "" : "문의처: " + campsite.tel
            let content = Content(title: campsite.facltNm,
                                  imageUrl: URL(string: imageUrl)!,
                                  description: description,
                                  link: appLink)
            let template = FeedTemplate(content: content, buttons: [button])
            
            if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
              
              if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
                  if let error = error {
                    print("error : \(error)")
                  }
                  else {
                    print("defaultLink(templateObject:templateJsonObject) success.")
                    guard let linkResult = linkResult else { return }
                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                  }
                }
              }
            }
          }
          else {
            print("카카오톡 미설치")
          }
        }
        .disposed(by: disposeBag)
      
    case .touristInfo(let touristInfo):
      // MARK: - Header Data
      let touristImageResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestTouristInfoImageList(contentId: touristInfo.contentId!)
        }
      
      let touristImageValue = touristImageResult
        .compactMap { [weak self] data -> [String]? in
          self?.detailUseCase.getValue(data)
        }
      
      let touristImageError = touristImageResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let touristCommonResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestTouristInfoCommon(contentId: touristInfo.contentId!, contentTypeId: touristInfo.contentTypeId)
        }
      
      let touristCommonValue = touristCommonResult
        .compactMap { [weak self] data -> [TouristInfoCommon]? in
          self?.detailUseCase.getValue(data)
        }
      
      let touristCommonError = touristCommonResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let headerValue = Observable.combineLatest(touristImageValue, touristCommonValue)
        .withUnretained(self)
        .compactMap { (owner, data) -> [DetailTouristInfoHeaderItem] in
          let (images, touristCommon) = data
          return owner.detailUseCase.requestHeaderData(
            touristInfo: touristInfo,
            touristCommon: touristCommon,
            images: images
          )
        }
      
      // MARK: - Location Data
      let weatherResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestWeatherList(
            lat: Double(touristInfo.mapY!)!,
            lon: Double(touristInfo.mapX!)!
          )
        }
      
      let weatherValue = weatherResult
        .compactMap { [weak self] data -> [WeatherInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let weatherError = weatherResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let locationValue = weatherValue
        .withUnretained(self)
        .map { (owner, weatherData) -> [DetailLocationItem] in
          owner.detailUseCase.requestLocationData(touristInfo: touristInfo, weatherData: weatherData)
        }
      
      // MARK: - Intro Data
      let touristIntroResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestTouristInfoIntro(contentId: touristInfo.contentId!, contentTypeId: touristInfo.contentTypeId)
        }
      
      let touristIntroValue = touristIntroResult
        .compactMap { [weak self] data -> [TouristInfoIntro]? in
          self?.detailUseCase.getValue(data)
        }
      
      let touristIntroError = touristIntroResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let introValue = touristIntroValue
        .withUnretained(self)
        .compactMap { (owner, intro) -> [any DetailTouristInfoIntroItem] in
          owner.detailUseCase.requestIntroData(
            intro: intro,
            contentType: touristInfo.contentTypeId
          )
        }
      
      // MARK: - Social Data
      let naverBlogResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestNaverBlogInfoList(keyword: touristInfo.title! ,display: 3)
        }
      
      let youtubeResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestYoutubeInfoList(keyword: touristInfo.title!, maxResults: 3)
        }
      
      let naverBlogValue = naverBlogResult
        .compactMap { [weak self] data -> [NaverBlogInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let naverBlogError = naverBlogResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let youtubeValue = youtubeResult
        .compactMap { [weak self] data -> [YoutubeInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let youtubeError = youtubeResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let socialValue = Observable.combineLatest(naverBlogValue, youtubeValue)
        .withUnretained(self)
        .compactMap{ (owner, social) -> [DetailSocialItem] in
          let (naverBlog, youtube) = social
          return owner.detailUseCase.requestSocialData(youtubeData: youtube, naverBlogData: naverBlog)
        }
      
      // MARK: - Around Data
      let aroundValue = input.viewWillAppear
        .compactMap { [weak self] _ in
          self?.detailUseCase.requestAroundData(touristInfo: touristInfo)
        }
      
      // MARK: - Image Data
      let imageValue = touristImageValue
        .compactMap { [weak self] data in
          self?.detailUseCase.requestImageData(images: data)
        }
      
      Observable.combineLatest(
        headerValue, locationValue,
        introValue, socialValue,
        aroundValue, imageValue
      )
      .withUnretained(self)
      .compactMap { (owner, values) -> [DetailTouristInfoSectionModel] in
        let (header, location, intro, social, around, image) = values
        return owner.detailUseCase.getDetailTouristInfoSectionModel(header, location, intro, social, around, image)
      }
      .bind(to: touristInfoData)
      .disposed(by: disposeBag)
      
      // MARK: - Around Tabman Data
      let touristResult = aroundTabmanViewModel.detailAroundTabmanSubViewModel.viewWillAppearWithContentType
        .withUnretained(self)
        .flatMapLatest { (owner, eventWithType) in
          let (_, contentType) = eventWithType
          return owner.detailUseCase.requestTouristInfoList(
            numOfRows: 20, pageNo: 1,
            contentTypeId: contentType,
            coordinate: Coordinate(
              latitude: Double(touristInfo.mapY!)!,
              longitude: Double(touristInfo.mapX!)!
            ),
            radius: 20000
          )
        }
      
      let touristValue = touristResult
        .compactMap { [weak self] data -> TouristInfoData? in
          self?.detailUseCase.getTouristInfoValue(data)
        }
      
      let touristError = touristResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getTouristInfoError(data)
        }
      
      touristValue
        .bind(to: aroundTabmanViewModel.detailAroundTabmanSubViewModel.resultCellData)
        .disposed(by: disposeBag)
      
      aroundTabmanViewModel.detailAroundTabmanSubViewModel.didSelectItemAt
        .subscribe { [weak self] (touristInfo, indexPath) in
          guard let self = self else { return }
          self.coordinator?.navigateToFlowDetail(with: .touristInfo(data: touristInfo))
        }
        .disposed(by: disposeBag)
      
      input.didSelectItemAt
        .withUnretained(self)
        .emit { (owner, itemWithIndex) in
          let (item, indexPath) = itemWithIndex
          switch indexPath.section {
          case 3:
            guard let item = item as? DetailSocialItem else { return }
            owner.coordinator?.navigateToFlowWeb(with: item.socialMediaInfo)
          case 5:
            guard let item = item as? DetailImageItem else { return }
            owner.coordinator?.navigateToFlowZoom(with: item.image)
          default:
            break
          }
        }
        .disposed(by: disposeBag)
      
      touristHeaderViewModel.pagerViewDidTapped
        .subscribe { [weak self] url in
          self?.coordinator?.navigateToFlowZoom(with: url)
        }
        .disposed(by: disposeBag)
      
      Observable.combineLatest(
        touristCommonValue,
        touristHeaderViewModel.callButtonDidTapped
      )
      .subscribe { [weak self] (common, _) in
        guard let common = common.first else { return }
        guard let tel = common.tel else { return }
        guard tel != "" else {
          self?.noUrlDataAlert.accept(("등록된 번호가 없습니다", "검색 엔진으로 이동하여 검색 하시겠습니까?", common.title!))
          return
        }
        
        print(tel)
        self?.callAlert.accept(("해당 번호로 전화를 거시겠습니까?", "📞 " + tel, tel))
      }
      .disposed(by: disposeBag)
      
      Observable.combineLatest(
        touristCommonValue,
        touristHeaderViewModel.reservationButtonDidTapped
      )
      .subscribe { [weak self] (common, _) in
        guard let common = common.first else { return }
        guard common.homepage != "" else {
          self?.noUrlDataAlert.accept(("등록된 홈페이지가 없습니다", "검색 엔진으로 이동하여 검색 하시겠습니까?", common.title!))
          return
        }
        guard let urlStr = common.homepage!.htmlToString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlStr) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
      .disposed(by: disposeBag)
      
      Observable.combineLatest(
        touristCommonValue,
        input.shareButtonDidTapped.asObservable()
      )
      .subscribe { [weak self] (common, _) in
        guard let common = common.first else { return }
        if ShareApi.isKakaoTalkSharingAvailable(){
          let appLink = Link(iosExecutionParams: ["second": "vvv"])
          let button = Button(title: "앱에서 보기", link: appLink)
          let imageUrl = touristInfo.mainImage!.isEmpty ? "https://images2.imgbox.com/3d/34/7xkF2x0U_o.png" : touristInfo.mainImage
          var description: String = ""
          description += common.homepage!.isEmpty ? "" : "홈페이지: " +
          common.homepage!.htmlToString
          let content = Content(title: touristInfo.title!,
                                imageUrl: URL(string: imageUrl!)!,
                                description: description,
                                link: appLink)
          let template = FeedTemplate(content: content, buttons: [button])
          
          if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
            
            if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
              ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
                if let error = error {
                  print("error : \(error)")
                }
                else {
                  print("defaultLink(templateObject:templateJsonObject) success.")
                  guard let linkResult = linkResult else { return }
                  UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                }
              }
            }
          }
        }
        else {
          print("카카오톡 미설치")
        }
      }
      .disposed(by: disposeBag)
      
      // MARK: - CLLocation Control
      input.isAutorizedLocation
        .emit(onNext: { [weak self] isEnable in
          guard let self = self else { return }
          if isEnable {
            self.updateLocationAction.accept(())
          } else {
            self.unAutorizedLocationAlert.accept(("위치 서비스 사용 불가", "아이폰 설정으로 이동합니다."))
          }
        })
        .disposed(by: disposeBag)
      
      input.isAutorizedLocation
        .emit(to: isAutorizedLocation)
        .disposed(by: disposeBag)
      
    }
    
    return Output(
      campsiteData: campsiteData.asDriver(onErrorJustReturn: []),
      touristInfoData: touristInfoData.asDriver(onErrorJustReturn: []),
      confirmAuthorizedLocation: confirmAuthorizedLocation.asSignal(),
      updateLocationAction: updateLocationAction.asSignal(),
      unAutorizedLocationAlert: unAutorizedLocationAlert.asSignal(),
      noUrlDataAlert: noUrlDataAlert.asSignal(),
      callAlert: callAlert.asSignal()
    )
  }
}


