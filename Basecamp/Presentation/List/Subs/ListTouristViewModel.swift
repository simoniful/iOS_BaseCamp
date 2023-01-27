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
  let viewWillAppear = PublishRelay<Void>()
  let didSelectItemAt = PublishRelay<(TouristInfo, IndexPath)>()
  let prefetchRowsAt = PublishRelay<[IndexPath]>()
  let refreshSignal = PublishRelay<Void>()
  
  let cellData: Driver<[TouristInfo]>
  let showToastAction = PublishRelay<String>()
  let reloadTable = PublishRelay<Void>()
  let endRefreshing = PublishRelay<Void>()
  let scrollToTop = PublishRelay<Void>()
  
  let resultCellData = PublishSubject<TouristInfoData>()
  let currentContentType = BehaviorRelay<TouristInfoContentType?>(value: nil)
  
  init() {
    self.cellData = resultCellData.compactMap{ $0.item }.asDriver(onErrorJustReturn: [])
  }
}




