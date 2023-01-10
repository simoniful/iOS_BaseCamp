//
//  DetailAroundTabmanSubViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/06.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailAroundTabmanSubViewModel {
  let viewWillAppearWithContentType = PublishRelay<(Void, TouristInfoContentType)>()
  let didSelectItemAt = PublishRelay<(TouristInfo, IndexPath)>()
  
  let resultCellData = PublishSubject<[TouristInfo]>()
  let cellData: Driver<[TouristInfo]>
  
  init() {
      self.cellData = resultCellData
          .asDriver(onErrorJustReturn: [])
  }
}
