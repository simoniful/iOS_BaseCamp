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
    let viewWillAppear: Signal<Void>
    let sortButtonTapped: Signal<Void>
  }
  struct Output {
    let data: Driver<[Campsite]>
  }
  
  private let filterCases = BehaviorRelay<[FilterCase]>(value: [])
  private let data = BehaviorRelay<[Campsite]>(value: [])
  
  lazy var filterMainViewModel = FilterMainViewModel(coordinator: coordinator, filterUseCase: mapUseCase)
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
//    input.viewDidLoad
//      .subscribe { [weak self] _ in
//        self?.data.accept((self?.mapUseCase.requestRealmData(area: nil, sigungu: nil))!)
//      }
//      .disposed(by: disposeBag)
    
    let realmValue = Observable.combineLatest(input.viewDidLoad, filterCases)
      .compactMap { (_, filterCases) in
        self.mapUseCase.requestRealmData(filterCases: filterCases)
      }
    
    Observable.combineLatest(
      filterMainViewModel.areaFilterState,
      filterMainViewModel.environmentFilerState,
      filterMainViewModel.facilityFilterState,
      filterMainViewModel.ruleFilterState,
      filterMainViewModel.petFilterState
    )
    .withUnretained(self)
    .compactMap { (owner, filterCases) in
      let (area, env, fclty, rule, pet) = filterCases
      return [area, env, fclty, rule, pet]
    }
    .bind(to: filterCases)
    .disposed(by: disposeBag)
    
    realmValue
      .bind(to: data)
      .disposed(by: disposeBag)
    
    input.sortButtonTapped
      .withUnretained(self)
      .emit { (owner, _) in
        owner.coordinator?.showFilterMainModal(owner.filterMainViewModel)
      }
      .disposed(by: disposeBag)
    
    return Output(
      data: data.asDriver(onErrorJustReturn: [])
    )
  }
}
