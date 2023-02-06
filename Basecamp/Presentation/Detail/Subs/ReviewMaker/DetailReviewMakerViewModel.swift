//
//  DetailReviewMakerViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/06.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailReviewMakerViewModel: ViewModel {
  struct Input {}
  struct Output {}
  
  var disposeBag = DisposeBag()
  func transform(input: Input) -> Output {
    return Output()
  }
}
