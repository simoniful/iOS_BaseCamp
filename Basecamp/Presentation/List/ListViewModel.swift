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
      .bind(to: listTouristViewModel.resultCellData)
      .disposed(by: disposeBag)
 
    
    return Output(
      sigunguReloadSignal: sigunguReloadSignal.asDriver(onErrorJustReturn: [])
    )
  }
}

extension ListViewModel {
//  func requestNewsList(isNeededToReset: Bool) {
//      if isNeededToReset {
//          currentPage = 0
//          totalCount = 0
//          newsList.accept([])
//      }
//
//      searchUseCase.request(
//          from: currentKeyword,
//          display: display,
//          start: (currentPage * display) + 1,
//          completionHandler: {[weak self] result in
//              guard let self = self else { return }
//              switch result {
//              case .success(let data):
//                  let newValue = data.item
//                  let oldValue = self.newsList.value
//                  self.newsList.accept(oldValue + newValue)
//                  self.currentPage += 1
//                  self.totalCount = data.total
//                  self.endRefreshing.accept(())
//                  if isNeededToReset {
//                      self.scrollToTop.accept(())
//                  }
//              case .failure(let error):
//                  self.showToastAction.accept(error.errorDescription)
//              }
//          })
//  }
}
