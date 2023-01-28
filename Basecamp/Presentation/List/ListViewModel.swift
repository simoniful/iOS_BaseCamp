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
    let sigunguReloadSignal: Driver<[String]>
  }
  
  public let areaState = BehaviorRelay<Area?>(value: nil)
  public let sigunguState = BehaviorRelay<Sigungu?>(value: nil)
  public let tabState = PublishRelay<ListTabBarContentType>()
  
  public let sigunguDataSource = BehaviorRelay<[Sigungu]>(value: [])
  private let sigunguReloadSignal = PublishRelay<[String]>()
  
  private let touristInfoList = BehaviorRelay<[TouristInfo]>(value: [])
  
  public let listCampsiteViewModel = ListCampsiteViewModel()
  public let listTouristViewModel = ListTouristViewModel()
  
  private var currentPage: Int = 0
  var totalCount = 0
  private let numOfRows: Int = 20
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    let sigunguCodeResult = areaState
      .withUnretained(self)
      .filter({ (owner, area) in
        area != nil
      })
      .flatMapLatest { (owner, area) in
        return owner.listUseCase.requestTouristInfoAreaCode(
          numOfRows: 35, pageNo: 1, areaCode: area!
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
        
    Observable.combineLatest(
      listCampsiteViewModel.viewWillAppear,
      areaState,
      sigunguState
    )
      .withUnretained(self)
      .compactMap { (owner, signals) in
        let (_, area, sigungu) = signals
        return owner.listUseCase.requestRealmData(area: area, sigungu: sigungu)
      }
      .bind(to: listCampsiteViewModel.resultCellData)
      .disposed(by: disposeBag)
    
    let touristInfoResult = Observable.combineLatest(
      listTouristViewModel.viewWillAppear,
      areaState,
      sigunguState,
      listTouristViewModel.currentContentType
    )
    .withUnretained(self)
    .flatMapLatest { (owner, signals) in
      let (_, area, sigungu, type) = signals
      owner.currentPage = 1
      owner.totalCount = 0
      owner.touristInfoList.accept([])
      return owner.listUseCase.requestTouristInfoList(
        numOfRows: owner.numOfRows,
        pageNo: owner.currentPage,
        areaCode: area,
        sigunguCode: sigungu,
        type: type
      )
    }
    .share()
    
    let touristInfoValue = touristInfoResult
      .withUnretained(self)
      .compactMap { (owner, data) -> TouristInfoData? in
        owner.listUseCase.getTouristInfoValue(data)
      }
    
    touristInfoValue
      .do(onNext: { data in
        print(data, "리스트 관광정보 데이터 패칭 ----")
      })
      .withUnretained(self)
      .compactMap { (owner, data) in
        owner.currentPage += 1
        owner.totalCount = data.totalCount
        owner.listTouristViewModel.endRefreshing.accept(())
        owner.listTouristViewModel.scrollToTop.accept(())
        return data.item
      }
      .bind(to: touristInfoList)
      .disposed(by: disposeBag)
    
    let touristInfoPrefetchResult = listTouristViewModel.prefetchRowsAt
      .withUnretained(self)
      .filter({ (owner, indexPaths) in
        indexPaths.contains { indexPath in
          let limitIndex = owner.touristInfoList.value.count - 1
          return limitIndex == indexPath.row && owner.touristInfoList.value.count < owner.totalCount
        }
      })
      .flatMapLatest({ (owner, indexPaths) in
        owner.listUseCase.requestTouristInfoList(
          numOfRows: owner.numOfRows,
          pageNo: owner.currentPage,
          areaCode: owner.areaState.value,
          sigunguCode: owner.sigunguState.value,
          type: owner.listTouristViewModel.currentContentType.value
        )
      })
      .share()
    
    let touristInfoPrefetchValue = touristInfoPrefetchResult
      .withUnretained(self)
      .compactMap { (owner, data) -> TouristInfoData? in
        owner.listUseCase.getTouristInfoValue(data)
      }
    
    
    touristInfoPrefetchValue
      .do(onNext: { data in
        print(data, "리스트 관광정보 데이터 패칭 ----")
      })
      .withUnretained(self)
      .compactMap { (owner, data) in
        let newValue = data.item
        let oldValue = owner.touristInfoList.value
        owner.currentPage += 1
        owner.totalCount = data.totalCount
        owner.listTouristViewModel.endRefreshing.accept(())
        return oldValue + newValue
      }
      .bind(to: touristInfoList)
      .disposed(by: disposeBag)
    
    
    
    
     
  
    touristInfoList
      .bind(to: listTouristViewModel.resultCellData)
      .disposed(by: disposeBag)
 

    return Output(
      sigunguReloadSignal: sigunguReloadSignal.asDriver(onErrorJustReturn: [])
    )
  }
}

