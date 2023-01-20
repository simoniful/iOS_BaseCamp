//
//  KeywordViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/20.
//

import Foundation
import RxSwift
import RxCocoa

final class KeywordViewModel: ViewModel {
  weak var coordinator: SearchCoordinator?
  private let searchUseCase: SearchUseCase
  
  init(coordinator: SearchCoordinator?, searchUseCase: SearchUseCase) {
      self.coordinator = coordinator
      self.searchUseCase = searchUseCase
  }
  
  struct Input {}
  
  struct Output {}
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    return Output()
  }
}
