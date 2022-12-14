//
//  HomeViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import RxSwift

final class HomeViewModel: ViewModel {
  private weak var coordinator: HomeCoordinator?
  private let homeUseCase: HomeUseCase
  
  init(coordinator: HomeCoordinator?, homeUseCase: HomeUseCase) {
      self.coordinator = coordinator
      self.homeUseCase = homeUseCase
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
