//
//  ListCampsiteViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa

struct ListCampsiteViewModel {
  let viewWillAppear = PublishRelay<Void>()
  let didSelectItemAtCampsite = PublishRelay<(Campsite, IndexPath)>()
  
  let resultCellData = PublishSubject<[Campsite]>()
  let cellData: Driver<[Campsite]>
  
  init() {
      self.cellData = resultCellData
          .asDriver(onErrorJustReturn: [])
  }
}
