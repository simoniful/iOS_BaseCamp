//
//  MyPageLikeViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageLikeViewModel: ViewModel {
  weak var coordinator: MyPageCoordinator?
  private let myPageUseCase: MyPageUseCase
  
  init(coordinator: MyPageCoordinator?, myPageUseCase: MyPageUseCase) {
    self.coordinator = coordinator
    self.myPageUseCase = myPageUseCase
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
    let didSelectItemAt: Signal<(Campsite, IndexPath)>
    let deleteAllButtonTapped: Signal<Void>
  }
  
  struct Output {
    let data: Driver<[Campsite]>
    let deleteAlert: Signal<(String, String)>
  }
  
  let data = BehaviorRelay<[Campsite]>(value: [])
  let deleteAllConfirmTapped = PublishRelay<Void>()
  let deleteAlert = PublishRelay<(String, String)>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    input.viewWillAppear
      .withUnretained(self)
      .compactMap { (owner, _) -> [Campsite] in
        return owner.myPageUseCase.requestLikedCampsiteData()
      }
      .bind(to: data)
      .disposed(by: disposeBag)
    
    input.didSelectItemAt
      .withUnretained(self)
      .emit { (owner, item) in
        let (campsite, _) = item
        owner.coordinator?.showDetailViewController(data: .campsite(data: campsite))
      }
      .disposed(by: disposeBag)
    
    input.deleteAllButtonTapped
      .withUnretained(self)
      .emit { (owner, _) in
        owner.deleteAlert.accept(("관심 캠핑장 목록 정리", "관심 캠핑장 목록을 비우시겠습니까?"))
      }
      .disposed(by: disposeBag)
    
    deleteAllConfirmTapped
      .withUnretained(self)
      .subscribe { (owner, _) in
        let campsites = owner.data.value
        owner.myPageUseCase.updateLikedCampsiteData(campsites: campsites)
        owner.data.accept([])
      }
      .disposed(by: disposeBag)
    
    return Output(
      data: data.asDriver(onErrorJustReturn: []),
      deleteAlert: deleteAlert.asSignal()
    )
  }
}
