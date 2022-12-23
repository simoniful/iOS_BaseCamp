//
//  HomeViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel {
  
  private weak var coordinator: HomeCoordinator?
  private let homeUseCase: HomeUseCase
  
  let homeCollectionViewModel = HomeCollectionViewModel()
  
  init(coordinator: HomeCoordinator?, homeUseCase: HomeUseCase) {
      self.coordinator = coordinator
      self.homeUseCase = homeUseCase
  }
  
  struct Input {
    let viewDidLoad: Observable<Void>
    let viewWillAppear: Observable<Void>
    
  }
  
  struct Output {

  }
  
  private let headerAction = PublishRelay<HeaderCellAction>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
//    let firstThemeCampsiteResult = input.viewDidLoad
//      .flatMapLatest { _ in
//        self.homeUseCase.requestCampsiteList(numOfRows: 20, pageNo: 1, keyword: "아이들")
//      }
//      .share()
//
//    let firstThemeCampsiteValue = firstThemeCampsiteResult
//      .compactMap { data -> [Campsite]? in
//        self.homeUseCase.getCampsiteValue(data)
//      }
//
//    let firstThemeError = firstThemeCampsiteResult
//      .compactMap { data -> String? in
//        self.homeUseCase.getCampsiteError(data)
//      }
    
    let campsiteResult = input.viewDidLoad
      .flatMapLatest { _ in
        self.homeUseCase.requestCampsiteList(numOfRows: 20, pageNo: 1, keyword: "반려동물")
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
    
    
    
    
    return Output()
  }
  
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        return self.headerSection()
      case 1:
        return self.regionSection()
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
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.2)), subitem: item, count: 1)
      let section = NSCollectionLayoutSection(group: group)
      return section
  }
  
  private func regionSection() -> NSCollectionLayoutSection {
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.2)), subitem: item, count: 1)
      let section = NSCollectionLayoutSection(group: group)
      return section
  }
  
  private func campsiteSection() -> NSCollectionLayoutSection {
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.2)), subitem: item, count: 1)
      let section = NSCollectionLayoutSection(group: group)
      return section
  }
  
  private func festivalSection() -> NSCollectionLayoutSection {
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.2)), subitem: item, count: 1)
      let section = NSCollectionLayoutSection(group: group)
      return section
  }
}

