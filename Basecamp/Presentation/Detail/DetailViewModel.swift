//
//  DetailViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: ViewModel {
  private weak var coordinator: Coordinator?
  private let detailUseCase: DetailUseCase
  
  init(coordinator: Coordinator?, detailUseCase: DetailUseCase) {
    self.coordinator = coordinator
    self.detailUseCase = detailUseCase
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
  
