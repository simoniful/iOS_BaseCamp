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
  }
  
  struct Output {
    let data: Driver<[DetailSectionModel]>
  }
  
  private let data = PublishRelay<[DetailSectionModel]>()
  private let aroundCellAction = PublishRelay<(DetailItem, IndexPath)>()
  private let aroundTabmanSubViewWillAppear = PublishRelay<Void>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    switch style {
    case .campsite(let campsite):
      // MARK: - Header Data
      let campsiteImageResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestCampsiteImageList(
            numOfRows: 30, pageNo: 1, contentId: campsite.contentID!
          )
        }
      
      let campsiteImageValue = campsiteImageResult
        .compactMap { data -> [String]? in
          self.detailUseCase.getValue(data)
        }
      
      let campsiteImageError = campsiteImageResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let headerValue = campsiteImageValue.map { images -> [DetailCampsiteHeaderItem] in
        self.detailUseCase.requestHeaderData(campsite: campsite, images: images)
      }
      
      // MARK: - Location Data
      let weatherResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestWeatherList(
            lat: Double(campsite.mapX!)!,
            lon: Double(campsite.mapY!)!
          )
        }
      
      let weatherValue = weatherResult
        .compactMap { data -> [WeatherInfo]? in
          self.detailUseCase.getValue(data)
        }
      
      let weatherError = weatherResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let locationValue = weatherValue.map { weatherData -> [DetailLocationItem] in
        self.detailUseCase.requestLocationData(campsite: campsite, weatherData: weatherData)
      }
      
      // MARK: - Facility Data
      let facilityValue = input.viewWillAppear
        .compactMap { _ in
          self.detailUseCase.requestFacilityData(campsite: campsite)
        }
      
      // MARK: - Info Data
      let infoValue = input.viewWillAppear
        .compactMap { _ in
          self.detailUseCase.requsetInfoData(campsite: campsite)
        }
      
      // MARK: - Social Data
      let naverBlogResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestNaverBlogInfoList(keyword: campsite.facltNm! ,display: 3)
        }

      let youtubeResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestYoutubeInfoList(keyword:campsite.facltNm!, maxResults: 3)
        }
      
      let naverBlogValue = naverBlogResult
        .compactMap { data -> [NaverBlogInfo]? in
          self.detailUseCase.getValue(data)
        }
      
      let naverBlogError = naverBlogResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let youtubeValue = youtubeResult
        .compactMap { data -> [YoutubeInfo]? in
          self.detailUseCase.getValue(data)
        }
      
      let youtubeError = youtubeResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let socialValue = Observable.combineLatest(naverBlogValue, youtubeValue) {
        naverBlog, youtube -> [DetailSocialItem] in
        self.detailUseCase.requestSocialData(youtubeData: youtube, naverBlogData: naverBlog)
      }
      
      // MARK: - Around Data
      let aroundValue = input.viewWillAppear
        .compactMap { _ in
          self.detailUseCase.requestAroundData(campsite:campsite)
        }
      
      // MARK: - Image Data
      let imageValue = campsiteImageValue
        .compactMap { data in
          self.detailUseCase.requestImageData(strings: data)
        }
      
      Observable.combineLatest(
        headerValue, locationValue,
        facilityValue, infoValue,
        socialValue, aroundValue,
        imageValue
      ) {
        header, location, facility, info, social, around, image -> [DetailCampsiteSectionModel] in
        self.detailUseCase.getDetailCampsiteSectionModel(header, location, facility, info, social, around, image)
      }
      .bind(to: data)
      .disposed(by: disposeBag)
      
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
          return cell
        case .locationSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLocationCell.identifier, for: indexPath) as? DetailLocationCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .facilitySection(header: let header, items: let items):
          <#code#>
        case .infoSection(items: let items):
          <#code#>
        case .socialSection(header: let header, items: let items):
          <#code#>
        case .aroundSection(header: let header, items: let items):
          <#code#>
        case .imageSection(header: let header, items: let items):
          <#code#>
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          <#code#>
        case .locationSection(header: let header, items: let items):
          <#code#>
        case .facilitySection(header: let header, items: let items):
          <#code#>
        case .infoSection(items: let items):
          <#code#>
        case .socialSection(header: let header, items: let items):
          <#code#>
        case .aroundSection(header: let header, items: let items):
          <#code#>
        case .imageSection(header: let header, items: let items):
          <#code#>
        }
      })
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 2:
        return self.facilitySection()
      case 4:
        return self.socialSection()
      case 6:
        return self.imageSection()
      default:
        return self.wholeSection()
      }
    }
  }
}

private extension DetailViewModel {
  func wholeSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height / 3)))
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height / 3)), subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
  func facilitySection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.7),
      heightDimension: .fractionalWidth(0.525)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 4.0
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
    section.orthogonalScrollingBehavior = .continuous
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  func socialSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.7),
      heightDimension: .fractionalWidth(0.525)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 4.0
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
    section.orthogonalScrollingBehavior = .continuous
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  func imageSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.4),
      heightDimension: .fractionalWidth(0.533)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
    section.interGroupSpacing = 4.0
    section.orthogonalScrollingBehavior = .continuous
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
           layoutSize: headerFooterSize,
           elementKind: UICollectionView.elementKindSectionHeader,
           alignment: .top
         )
    
    section.boundarySupplementaryItems = [header]
    return section
  }
  
  
}
  
