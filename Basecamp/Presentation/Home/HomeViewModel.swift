//
//  HomeViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import RxSwift

final class HomeViewModel: ViewModel {
  private weak var coordinator: HomeCoordinator?
  
  // MainModel의 역할을 useCase로 분리
  private let homeUseCase: HomeUseCase
  
  let homeCollectionViewModel = HomeCollectionViewModel()
  
  init(coordinator: HomeCoordinator?, homeUseCase: HomeUseCase) {
      self.coordinator = coordinator
      self.homeUseCase = homeUseCase
  }
  
  struct Input {
    // viewDidLoad - Campsite, Festival 
    // viewWillAppear - Realm
  }
  
  struct Output {

  }
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
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

