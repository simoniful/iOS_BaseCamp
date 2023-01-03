//
//  DetailViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import RxCocoa

enum DetailStyle {
  case campsite(campsite: Campsite)
  case touristInfo(touristInfo :TouristInfo)
}

final class DetailViewModel: ViewModel {
  private weak var coordinator: Coordinator?
  private let detailUseCase: DetailUseCase
  private let style: DetailStyle
  
  init(coordinator: Coordinator?, detailUseCase: DetailUseCase, style: DetailStyle) {
    self.coordinator = coordinator
    self.detailUseCase = detailUseCase
    self.style = style
  }
  
  struct Input {
  }
  
  struct Output {
  }
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    return Output()
  }
  
  func a() {
    switch self.style {
      
    case .campsite(campsite: let campsite):
      <#code#>
    case .touristInfo(touristInfo: let touristInfo):
      <#code#>
    }
  }
}
  
