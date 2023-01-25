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
  
  struct Input {
    let searchKeyword: Observable<String>
    let cancelButtonTapped: Signal<Void>
    let searchButtonTapped: Signal<Void>
    let didSelectItemAt: Signal<(Campsite, IndexPath)>
  }
  
  struct Output {
    let data: Driver<[Campsite]>
    let invalidKeywordSignal: Driver<Void>
    let emptyResultSignal: Driver<Void>
  }
  
  public let data = PublishRelay<[Campsite]>()
  private let invalidKeywordSignal = PublishRelay<Void>()
  private let emptyResultSignal = PublishRelay<Void>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    input.searchKeyword
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .do(onNext: { [weak self] keyword in
        if keyword.count < 2 { self?.invalidKeywordSignal.accept(()) }
      })
      .filter({ $0.count > 1 })
      .withUnretained(self)
      .compactMap { (owner, keyword) -> [Campsite] in
        owner.searchUseCase.requestRealmData(keyword: keyword)
      }
      .do(onNext: { [weak self] camplist in
        if camplist.isEmpty { self?.emptyResultSignal.accept(())}
      })
      .bind(to: data)
      .disposed(by: disposeBag)
    
    return Output(
      data: data.asDriver(onErrorJustReturn: []),
      invalidKeywordSignal: invalidKeywordSignal.asDriver(onErrorJustReturn: ()),
      emptyResultSignal: emptyResultSignal.asDriver(onErrorJustReturn: ())
    )
  }
}
