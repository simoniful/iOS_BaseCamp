//
//  HomeCollectionViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/15.
//

import Foundation
import RxSwift
import RxCocoa

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
}
