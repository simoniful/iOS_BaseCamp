//
//  HomeViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewModel: ViewModel {
  
  private weak var coordinator: HomeCoordinator?
  private let homeUseCase: HomeUseCase
   
  init(coordinator: HomeCoordinator?, homeUseCase: HomeUseCase) {
      self.coordinator = coordinator
      self.homeUseCase = homeUseCase
  }
  
  struct Input {
    let viewDidLoad: Observable<Void>
    let viewWillAppear: Observable<Void>
    let didSelectItemAt: Signal<(HomeItem, IndexPath)>
  }
  
  struct Output {
    let data: Driver<[HomeSectionModel]>
  }
  
  private let viewDidLoad = PublishRelay<Void>()
  private let data = PublishRelay<[HomeSectionModel]>()
  private let headerAction = PublishRelay<HeaderCellAction>()
 
  // private let userArea = BehaviorRelay<Area>(value: .서울특별시)
  // private let userSigungu = BehaviorRelay<Sigungu>(value: Sigungu(rnum: <#T##Int?#>, code: <#T##String?#>, name: <#T##String?#>))
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    let realmValue = input.viewWillAppear
      .compactMap{ _ in
        self.homeUseCase.requestRealmData()
      }

    let areaValue = input.viewWillAppear
      .compactMap { _ in
        self.homeUseCase.requestAreaData()
      }

    let campsiteResult = input.viewWillAppear
      .flatMapLatest { _ in
        self.homeUseCase.requestCampsiteList(numOfRows: 20, pageNo: 1, keyword: "글램핑")
      }
      .share()

    let campsiteValue = campsiteResult
      .compactMap { data -> [Campsite]? in
        self.homeUseCase.getCampsiteValue(data)
      }

    let campsiteError = campsiteResult
      .compactMap { data -> String? in
        self.homeUseCase.getCampsiteError(data)
      }

    let touristInfoResult = input.viewWillAppear
      .flatMapLatest { _ in
        self.homeUseCase.requestTouristInfoList(
          numOfRows: 15, pageNo: 1, areaCode: nil, sigunguCode: nil
        )
      }
      .share()

    let touristInfoValue = touristInfoResult
      .compactMap { data -> [TouristInfo]? in
        self.homeUseCase.getTouristInfoValue(data)
      }

    let touristInfoError = touristInfoResult
      .compactMap { data -> String? in
        self.homeUseCase.getTouristInfoError(data)
      }

    Observable.combineLatest(realmValue, areaValue, campsiteValue, touristInfoValue) { realmData, areaData, campsiteList, touristList -> [HomeSectionModel] in
      self.homeUseCase.getHomeSectionModel( realmData, areaData, campsiteList, touristList)
    }
    .bind(to: data)
    .disposed(by: disposeBag)
    
    headerAction
      .capture(case: HeaderCellAction.map)
      .bind { _ in
        print("지도화면 전환")
      }
      .disposed(by: disposeBag)
    
    headerAction
      .capture(case: HeaderCellAction.myMenu)
      .bind { _ in
        print("마이메뉴 전환")
      }
      .disposed(by: disposeBag)
    
    headerAction
      .capture(case: HeaderCellAction.search)
      .bind { _ in
        print("검색 전환")
      }
      .disposed(by: disposeBag)
      
    input.didSelectItemAt
      .emit { (model, index) in
        switch index.section {
        case 0:
          print("여긴 클릭하면 안됨")
        default:
          print(model)
        }
      }
      .disposed(by: disposeBag)
    
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
  
  func dataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCell.identifier, for: indexPath) as? HomeHeaderCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(completedCount: item.completedCampsiteCount, likedCount: item.likedCampsiteCount)
          cell.viewModel(item: item)
            .bind(to: self.headerAction)
            .disposed(by: cell.disposeBag)
          return cell
        case .areaSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAreaCell.identifier, for: indexPath) as? HomeAreaCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(area: item.area)
          return cell
        case .campsiteSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCampsiteCell.identifier, for: indexPath) as? HomeCampsiteCell else { return UICollectionViewCell() }
          let item = items[indexPath.row]
          cell.setData(campsite: item)
          return cell
        case .festivalSection(header: _, items: let items):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFestivalCell.identifier, for: indexPath) as? HomeFestivalCell else { return UICollectionViewCell() }
        let item = items[indexPath.row]
        cell.setData(touristInfo: item)
        return cell
        }
      }
      ,
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .headerSection:
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.identifier, for: indexPath)
          return header
        case .areaSection(header: let headerStr, _),
             .campsiteSection(header: let headerStr, _),
             .festivalSection(header: let headerStr, _):
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.identifier, for: indexPath) as? HomeSectionHeader else { return UICollectionReusableView() }
          header.setData(header: headerStr)
          return header
        }
      }
    )
    return dataSource
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        return self.headerSection()
      case 1:
        return self.areaSection()
      case 3:
        return self.festivalSection()
      default:
        return self.campsiteSection()
      }
    }
  }
}

private extension HomeViewModel {
  func headerSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height / 3)))
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UIScreen.main.bounds.height / 3)), subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
  private func areaSection() -> NSCollectionLayoutSection {
    let estimatedHeight: CGFloat = 50
    let estimatedWidth: CGFloat = 50
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                          heightDimension: .estimated(estimatedHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .estimated(estimatedHeight))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
    
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    
    let header = NSCollectionLayoutBoundarySupplementaryItem(
           layoutSize: headerFooterSize,
           elementKind: UICollectionView.elementKindSectionHeader,
           alignment: .top
         )
    
    section.boundarySupplementaryItems = [header]
    return section
    
  }
  
  private func campsiteSection() -> NSCollectionLayoutSection {
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
  
  private func festivalSection() -> NSCollectionLayoutSection {
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

