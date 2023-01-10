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

// 스타일에 따른 다른 데이터 소스/레이아웃 구성
enum DetailStyle {
  case campsite(campsite: Campsite)
  case touristInfo(touristInfo :TouristInfo)
}

final class DetailViewModel: ViewModel {
  private weak var coordinator: Coordinator?
  private let detailUseCase: DetailUseCase
  let style: DetailStyle
  
  init(coordinator: Coordinator?, detailUseCase: DetailUseCase, style: DetailStyle) {
    self.coordinator = coordinator
    self.detailUseCase = detailUseCase
    self.style = style
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
    let isAutorizedLocation: Signal<Bool>
  }
  
  struct Output {
    let data: Driver<[DetailCampsiteSectionModel]>
    let confirmAuthorizedLocation: Signal<Void>
    let updateLocationAction: Signal<Void>
    let unAutorizedLocationAlert: Signal<(String, String)>
  }
  
  let aroundTabmanViewModel = DetailAroundTabmanViewModel()
  let locationViewModel = DetailLocationCellViewModel()
  
  private let data = PublishRelay<[DetailCampsiteSectionModel]>()
  private let locationAuthorization = BehaviorRelay<Bool>(value: false)
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    switch style {
    case .campsite(let campsite):
      // MARK: - Header Data
      let campsiteImageResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestCampsiteImageList(
            numOfRows: 30, pageNo: 1, contentId: campsite.contentID!
          )
        }
      
      let campsiteImageValue = campsiteImageResult
        .do(onNext: { data in
          print(data, "캠핑 이미지 데이터 패칭 ----")
        })
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
            lat: Double(campsite.mapY!)!,
            lon: Double(campsite.mapX!)!
          )
        }
      
      let weatherValue = weatherResult
        .do(onNext: { data in
          print(data, "날씨 데이터 패칭 ----")
        })
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
          owner.detailUseCase.requestNaverBlogInfoList(keyword: campsite.facltNm! ,display: 3)
        }

      let youtubeResult = input.viewWillAppear
        .withUnretained(self)
        .flatMapLatest { (owner, _) in
          owner.detailUseCase.requestYoutubeInfoList(keyword: campsite.facltNm!, maxResults: 3)
        }
      
      let naverBlogValue = naverBlogResult
        .do(onNext: { data in
          print(data, "네이버 데이터 패칭 ----")
        })
        .compactMap { [weak self] data -> [NaverBlogInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let naverBlogError = naverBlogResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      let youtubeValue = youtubeResult
        .do(onNext: { data in
          print(data, "유튜브 데이터 패칭 ----")
        })
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
          self?.detailUseCase.requestAroundData(campsite:campsite)
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
      .bind(to: data)
      .disposed(by: disposeBag)
      
      let touristResult = aroundTabmanViewModel.detailAroundTabmanSubViewModel.viewWillAppearWithContentType
        .withUnretained(self)
        .flatMapLatest { (owner, eventWithType) in
          let (_, contentType) = eventWithType
          return owner.detailUseCase.requestTouristInfoList(
            numOfRows: 15, pageNo: 1,
            contentTypeId: contentType,
            coordinate: Coordinate(
              latitude: Double(campsite.mapY!)!,
              longitude: Double(campsite.mapX!)!
            ),
            radius: 10000
          )
        }
        
      let touristValue = touristResult
        .do(onNext: { data in
          print(data, "관광정보 데이터 패칭 ----")
        })
        .compactMap { [weak self] data -> [TouristInfo]? in
          self?.detailUseCase.getValue(data)
        }
      
      let touristError = touristResult
        .compactMap { [weak self] data -> String? in
          self?.detailUseCase.getError(data)
        }
      
      touristValue
        .bind(to: aroundTabmanViewModel.detailAroundTabmanSubViewModel.resultCellData)
        .disposed(by: disposeBag)
      
      locationAuthorization
        .subscribe { isAuth in
          <#code#>
        }
      
      
    case .touristInfo(let touristInfo):
      break
    }
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
  
  func campsiteDataSource() -> RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHeaderCell.identifier, for: indexPath) as? DetailHeaderCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          // cell.viewModel로 버튼 enum 구성
          return cell
        case .locationSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLocationCell.identifier, for: indexPath) as? DetailLocationCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          cell.viewModel(item: item)
            .bind(to: self.locationAuthorization)
            .disposed(by: disposeBag)
          return cell
        case .facilitySection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFacilityCell.identifier, for: indexPath) as? DetailFacilityCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .infoSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailInfoCell.identifier, for: indexPath) as? DetailInfoCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .socialSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSocialCell.identifier, for: indexPath) as? DetailSocialCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .aroundSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAroundCell.identifier, for: indexPath) as? DetailAroundCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.parent = self
          cell.setupData(data: item)
          return cell
        case .imageSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .headerSection,
             .infoSection:
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath)
          return header
        case .locationSection(header: let headerStr, _),
             .facilitySection(header: let headerStr, _),
             .socialSection(header: let headerStr, _),
             .aroundSection(header: let headerStr, _),
             .imageSection(header: let headerStr, _):
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath) as? DetailSectionHeader else { return UICollectionReusableView() }
          header.setData(header: headerStr)
          return header
        }
      }
    )
    return dataSource
  }
}


