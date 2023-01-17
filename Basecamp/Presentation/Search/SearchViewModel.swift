//
//  SearchViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/13.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModel {
  private weak var coordinator: SearchCoordinator?
  private let searchUseCase: SearchUseCase
  
  init(coordinator: SearchCoordinator?, searchUseCase: SearchUseCase) {
      self.coordinator = coordinator
      self.searchUseCase = searchUseCase
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
    let searchButtonTapped: Signal<Void>
    let didSelectItemAt: Signal<(Campsite, IndexPath)>
  }
  
  struct Output {
    let data: Driver<[Campsite]>
  }
  
  private let filterCases = BehaviorRelay<[FilterCase]>(value: [])
  private let data = PublishRelay<[Campsite]>()
  
  lazy var searchHeaderViewModel = SearchHeaderViewModel()
  lazy var filterMainViewModel = FilterMainViewModel(coordinator: coordinator, searchUseCase: searchUseCase)
  
  var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let realmValue = input.viewWillAppear
      .compactMap { _ in
        self.searchUseCase.requestRealmData(filterCase: [])
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
    .do(onNext: { arr in
      print(arr)
    })
    .bind(to: filterCases)
    .disposed(by: disposeBag)

    realmValue
      .bind(to: data)
      .disposed(by: disposeBag)
    
    searchHeaderViewModel.sortButtonTapped
      .withUnretained(self)
      .subscribe { (owner, _) in
        owner.coordinator?.showFilterMainModal(owner.filterMainViewModel)
      }
      .disposed(by: disposeBag)
    
    
    
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
}
