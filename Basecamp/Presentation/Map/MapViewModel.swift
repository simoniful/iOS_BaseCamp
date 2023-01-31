//
//  MapViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/29.
//

import Foundation
import RxSwift
import RxCocoa


final class MapViewModel: ViewModel {
  weak var coordinator: MapCoordinator?
  private let mapUseCase: MapUseCase
  
  init(coordinator: MapCoordinator?, mapUseCase: MapUseCase) {
    self.coordinator = coordinator
    self.mapUseCase = mapUseCase
  }
  
  struct Input {
    let viewDidLoad: Observable<Void>
  }
  struct Output {
    let data: Observable<[Campsite]>
  }
  
  private let data = PublishRelay<[Campsite]>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    let realmValue = input.viewDidLoad
      .compactMap { [weak self] _ in
        self?.mapUseCase.requestRealmData(area: nil, sigungu: nil)
      }
    
    realmValue
      .bind(to: data)
      .disposed(by: disposeBag)
    
    return Output(
      data: data.asObservable()
    )
  }
}
