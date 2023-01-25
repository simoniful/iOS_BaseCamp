//
//  ListViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ListViewModel: ViewModel {
  weak var coordinator: ListCoordinator?
  private let listUseCase: ListUseCase
  
  init(coordinator: ListCoordinator?, listUseCase: ListUseCase, area: Area?) {
    self.coordinator = coordinator
    self.listUseCase = listUseCase
    if let area = area {
      areaState.accept(area)
    }
  }
  
  struct Input {
    let viewDidLoad: Observable<Void>
    
  }
  
  struct Output {
    let campData: Driver<[Campsite]>
    let touristData: Driver<[TouristInfo]>
    let sigunguReloadSignal: Driver<[String]>
  }
  
  public let areaState = PublishRelay<Area>()
  public let sigunguState = PublishRelay<Sigungu>()
  private let campData = PublishRelay<[Campsite]>()
  private let touristData = PublishRelay<[TouristInfo]>()
  
  public var sigunguDataSource = BehaviorRelay<[Sigungu]>(value: [])
  private let sigunguReloadSignal = PublishRelay<[String]>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    let sigunguCodeResult = areaState
      .withUnretained(self)
      .flatMapLatest { (owner, area) in
        owner.listUseCase.requestTouristInfoAreaCode(
          numOfRows: 35, pageNo: 1, areaCode: area
        )
      }
      .share()
    
    let sigunguCodeValue = sigunguCodeResult
      .do(onNext: { data in
        print(data, "리스트 관광정보 코드 데이터 패칭 ----")
      })
      .withUnretained(self)
      .compactMap { (owner, data) -> [Sigungu]? in
        owner.listUseCase.getValue(data)
      }
    
    sigunguCodeValue
      .do(onNext: {[weak self] list in
        self?.sigunguReloadSignal.accept(list.map{ $0.name! })
      })
      .bind(to: sigunguDataSource)
      .disposed(by: disposeBag)
    
   
    
    return Output(
      campData: campData.asDriver(onErrorJustReturn: []),
      touristData: touristData.asDriver(onErrorJustReturn: []),
      sigunguReloadSignal: sigunguReloadSignal.asDriver(onErrorJustReturn: [])
    )
  }
}

extension ListViewModel {
  
}
