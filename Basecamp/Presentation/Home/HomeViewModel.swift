//
//  HomeViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewModel: ViewModel {
  
  private weak var coordinator: HomeCoordinatorProtocol?
  private let homeUseCase: HomeUseCase
  
  init(coordinator: HomeCoordinatorProtocol?, homeUseCase: HomeUseCase) {
    self.coordinator = coordinator
    self.homeUseCase = homeUseCase
  }
  
  struct Input {
    let viewDidLoad: Observable<Void>
    let viewWillAppear: Observable<Void>
    let didSelectItemAt: Signal<(HomeItem, IndexPath)>
    let searchButtonDidTapped: Signal<Void>
    let listButtonDidTapped: Signal<Void>
    let mapButtonDidTapped: Signal<Void>
  }
  
  struct Output {
    var data: Driver<[HomeSectionModel]>
  }
  
  public let data = BehaviorRelay<[HomeSectionModel]>(value: [])
  public let headerAction = PublishRelay<HeaderCellAction>()
  
  var disposeBag = DisposeBag()
  func transform(input: Input) -> Output {
    let realmValue = input.viewWillAppear
      .compactMap{ _ in
        self.homeUseCase.requestRealmData()
      }

    let areaValue = input.viewDidLoad
      .compactMap { _ in
        self.homeUseCase.requestAreaData()
      }

    let campsiteKeywordValue = input.viewWillAppear
      .compactMap { _ in
        self.homeUseCase.requestCampsiteTypeList()
      }
    
    let campsiteThemeValue = input.viewWillAppear
      .compactMap { [weak self] _ in
        self?.homeUseCase.requestCampsiteThemeList()
      }
    
    let touristInfoResult = input.viewDidLoad
      .flatMapLatest { _ in
        self.homeUseCase.requestTouristInfoList(
          numOfRows: 20, pageNo: 1, areaCode: nil, sigunguCode: nil
        )
      }
      .share()

    let touristInfoValue = touristInfoResult
      .compactMap { data -> TouristInfoData? in
        return self.homeUseCase.getTouristInfoValue(data)
      }

    let touristInfoError = touristInfoResult
      .compactMap { data -> String? in
        return self.homeUseCase.getTouristInfoError(data)
      }

    Observable.combineLatest(realmValue, areaValue, campsiteKeywordValue, campsiteThemeValue ,touristInfoValue)
      .withUnretained(self)
      .compactMap { (owner, values) -> [HomeSectionModel] in
        let (realmData, areaData, campsiteKeywordList, campsiteThemeList, touristList) = values
        return owner.homeUseCase.getHomeSectionModel(realmData, areaData, campsiteKeywordList, campsiteThemeList, touristList.item)
      }
      .bind(to: data)
      .disposed(by: disposeBag)
    
    headerAction
      .capture(case: HeaderCellAction.map)
      .bind { [weak self] _ in
        self?.coordinator?.changeTabByIndex(tabCase: .map, message: "지도에서 검색해보세요", area: nil, index: 0)
      }
      .disposed(by: disposeBag)
    
    headerAction
      .capture(case: HeaderCellAction.myMenu)
      .bind { [weak self] _ in
        self?.coordinator?.changeTabByIndex(tabCase: .mypage, message: "캠핑로그를 확인해보세요", area: nil, index: 0)
      }
      .disposed(by: disposeBag)
    
    headerAction
      .capture(case: HeaderCellAction.search)
      .bind { [weak self] _ in
        self?.coordinator?.changeTabByIndex(tabCase: .search, message: "조건별로 검색해보세요", area: nil, index: 0)
      }
      .disposed(by: disposeBag)
      
    input.didSelectItemAt
      .emit { [weak self] (model, index) in
        switch index.section {
        case 0:
          break
        case 1:
          guard let areaItem = model as? HomeAreaItem else { return }
          self?.coordinator?.changeTabByIndex(tabCase: .list, message: "지역별로 검색해보세요", area: areaItem.area, index: index.row)
        case 2, 3:
          guard let campsite = model as? Campsite else { return }
          self?.coordinator?.navigateToFlowDetail(with: .campsite(data: campsite))
        case 4:
          guard let touristInfo = model as? TouristInfo else { return }
          self?.coordinator?.navigateToFlowDetail(with: .touristInfo(data: touristInfo))
        default:
          break
        }
      }
      .disposed(by: disposeBag)
    
    input.searchButtonDidTapped
      .withUnretained(self)
      .emit { owner, _ in
        owner.coordinator?.changeTabByIndex(tabCase: .search, message: "조건별로 검색해보세요", area: nil, index: 0)
      }
      .disposed(by: disposeBag)
    
    input.listButtonDidTapped
      .withUnretained(self)
      .emit { owner, _ in
        owner.coordinator?.changeTabByIndex(tabCase: .list, message: "지역별로 검색해보세요", area: nil, index: 0)
      }
      .disposed(by: disposeBag)
    
    input.mapButtonDidTapped
      .withUnretained(self)
      .emit { owner, _ in
        owner.coordinator?.changeTabByIndex(tabCase: .map, message: "지도에서 검색해보세요", area: nil, index: 0)
      }
      .disposed(by: disposeBag)
    
    return Output(
      data: data.asDriver(onErrorJustReturn: [])
    )
  }
}


