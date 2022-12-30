//
//  HomeCollectionViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeCollectionViewModel: ViewModel {
  
  let resultCellData = PublishSubject<[HomeSectionModel]>()
  let cellData: Driver<[HomeSectionModel]>
  
  init() {
    self.cellData = resultCellData
      .asDriver(onErrorJustReturn: [])
  }
  
  struct Input {
    
  }
  
  struct Output {

  }
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    return Output()
  }
  
  func dataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          <#code#>
        case .areaSection(items: let items):
          <#code#>
        case .campsiteSection(header: let header, items: let items):
          <#code#>
        case .festivalSection(items: let items):
          <#code#>
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          <#code#>
        case .areaSection(items: let items):
          <#code#>
        case .campsiteSection(header: let header, items: let items):
          <#code#>
        case .festivalSection(items: let items):
          <#code#>
        }
      }
    )
    return dataSource
  }
}
