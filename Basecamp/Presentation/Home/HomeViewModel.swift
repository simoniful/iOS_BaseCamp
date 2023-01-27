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
  
  private let data = PublishRelay<[HomeSectionModel]>()
  private let headerAction = PublishRelay<HeaderCellAction>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    input.viewDidLoad
      .subscribe { [weak self] _ in
        self?.homeUseCase.requestSavefromLocalJson()
      }
      .disposed(by: disposeBag)
    
    let realmValue = input.viewDidLoad
      .compactMap{ _ in
        self.homeUseCase.requestRealmData()
      }

    let areaValue = input.viewDidLoad
      .compactMap { _ in
        self.homeUseCase.requestAreaData()
      }

    let campsiteResult = input.viewDidLoad
      .flatMapLatest { _ in
        self.homeUseCase.requestCampsiteList(numOfRows: 20, pageNo: 1, keyword: "글램핑")
      }
      .share()

    let campsiteValue = campsiteResult
      .do(onNext: { data in
        print(data, "홈 캠핑 데이터 패칭 ----")
      })
      .compactMap { data -> [Campsite]? in
        self.homeUseCase.getCampsiteValue(data)
      }

    let campsiteError = campsiteResult
      .compactMap { data -> String? in
        self.homeUseCase.getCampsiteError(data)
      }

    let touristInfoResult = input.viewDidLoad
      .flatMapLatest { _ in
        self.homeUseCase.requestTouristInfoList(
          numOfRows: 15, pageNo: 1, areaCode: nil, sigunguCode: nil
        )
      }
      .share()

    let touristInfoValue = touristInfoResult
      .do(onNext: { data in
        print(data, "홈 관광정보 데이터 패칭 ----")
      })
      .compactMap { data -> TouristInfoData? in
        self.homeUseCase.getTouristInfoValue(data)
      }

    let touristInfoError = touristInfoResult
      .compactMap { data -> String? in
        self.homeUseCase.getTouristInfoError(data)
      }

    Observable.combineLatest(realmValue, areaValue, campsiteValue, touristInfoValue)
      .do(onNext: { _ in
        print("home 데이터 패칭 완료")
      })
      .withUnretained(self)
      .compactMap { (owner, values) -> [HomeSectionModel] in
        let (realmData, areaData, campsiteList, touristList) = values
        return owner.homeUseCase.getHomeSectionModel( realmData, areaData, campsiteList, touristList.item)
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
        case 1:
          guard let areaItem = model as? HomeAreaItem else { return }
          self.coordinator?.changeTabByIndex(tabCase: .list, message: "지역별로 검색해보세요", area: areaItem.area)
        case 2:
          guard let campsite = model as? Campsite else { return }
          self.coordinator?.showDetailViewController(detailStyle: .campsite(campsite: campsite), name: campsite.facltNm!)
        case 3:
          guard let touristInfo = model as? TouristInfo else { return }
          self.coordinator?.showDetailViewController(detailStyle: .touristInfo(touristInfo: touristInfo), name: touristInfo.title!)
        default:
          print("여긴 클릭하면 안됨")
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
          cell.viewModel(item: item)?
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
      },
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
    section.contentInsets = .init(top: 0, leading: 16.0, bottom: 32.0, trailing: 16.0)
    return section
  }
  
  func areaSection() -> NSCollectionLayoutSection {
    let estimatedHeight: CGFloat = 50
    let estimatedWidth: CGFloat = (UIScreen.main.bounds.width - 8 * 5) / 6
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                          heightDimension: .estimated(estimatedHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: nil , bottom: .fixed(8))
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .estimated(estimatedHeight))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitem: item, count: 6)
    group.interItemSpacing = .fixed(8.0)
  
    let section = NSCollectionLayoutSection(group: group)
    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25.0))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
           layoutSize: headerFooterSize,
           elementKind: UICollectionView.elementKindSectionHeader,
           alignment: .top
         )
    section.boundarySupplementaryItems = [header]
    section.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 32.0, trailing: 16.0)
    return section
  }
  
  func campsiteSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.6),
      heightDimension: .fractionalWidth(0.45)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8.0
    section.contentInsets = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 32.0, trailing: 16.0)
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
    // item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.45),
      heightDimension: .fractionalWidth(0.6)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 32.0, trailing: 16.0)
    section.interGroupSpacing = 8.0
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

