//
//  ListTouristViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa

struct ListTouristViewModel {
  let viewWillAppearWithContentType = PublishRelay<(Void, TouristInfoContentType)>()
  let didSelectItemAt = PublishRelay<(TouristInfo, IndexPath)>()
  let prefetchRowsAt = PublishRelay<[IndexPath]>()
  
  let resultCellData = PublishSubject<[TouristInfo]>()
  let cellData: Driver<[TouristInfo]>
  
  init() {
      self.cellData = resultCellData
          .asDriver(onErrorJustReturn: [])
  }
}
