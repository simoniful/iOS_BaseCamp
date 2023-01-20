//
//  FilterMainViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/14.
//

import Foundation
import RxSwift
import RxCocoa

class FilterMainViewModel: ViewModel {
  private weak var coordinator: SearchCoordinator?
  private let searchUseCase: SearchUseCase
  
  init(coordinator: SearchCoordinator?, searchUseCase: SearchUseCase) {
      self.coordinator = coordinator
      self.searchUseCase = searchUseCase
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
    let didSelectItemAt: Signal<(FilterCase, IndexPath)>
    let didTapClearButton: Signal<Void>
  }
  
  struct Output {
    let data: Driver<[FilterCase]>
  }
  
  lazy var filterSubViewModel = FilterSubViewModel(coordinator: coordinator, searchUseCase: searchUseCase)

  private let data = BehaviorRelay(value: [
    FilterCase.area(nil),
    FilterCase.environment(nil, nil),
    FilterCase.facility(nil, nil, nil),
    FilterCase.rule(nil, nil),
    FilterCase.pet(nil, nil)
  ])
  
  let areaFilterState = BehaviorRelay<FilterCase>(value: FilterCase.area(nil))
  let environmentFilerState = BehaviorRelay<FilterCase>(value: FilterCase.environment(nil, nil))
  let facilityFilterState = BehaviorRelay<FilterCase>(value: FilterCase.facility(nil, nil, nil))
  let ruleFilterState = BehaviorRelay<FilterCase>(value: FilterCase.rule(nil, nil))
  let petFilterState = BehaviorRelay<FilterCase>(value: FilterCase.pet(nil, nil))
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    Observable.combineLatest(areaFilterState, environmentFilerState, facilityFilterState, ruleFilterState, petFilterState)
      .compactMap({ (area, env, fclty, rule, pet) in
        return [area, env, fclty, rule, pet]
      })
      .bind(to: data)
      .disposed(by: disposeBag)

    input.didSelectItemAt
      .withUnretained(self)
      .emit { (owner, item) in
        let (model, _) = item
        owner.coordinator?.showFilterSubViewController(owner.filterSubViewModel, type: model)
      }
      .disposed(by: disposeBag)
    
    input.didTapClearButton
      .withUnretained(self)
      .emit { (owner, _) in
        owner.areaFilterState.accept(.area(nil))
        owner.environmentFilerState.accept(.environment(nil, nil))
        owner.facilityFilterState.accept(.facility(nil, nil, nil))
        owner.ruleFilterState.accept(.rule(nil, nil))
        owner.petFilterState.accept(.pet(nil, nil))
      }
      .disposed(by: disposeBag)
    
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
}
