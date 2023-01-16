//
//  FilterSubViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/16.
//

import Foundation
import RxSwift
import RxCocoa

struct QueryItem {
  let name: String
  var selected: Bool
}

final class FilterSubViewModel: ViewModel {
  private weak var coordinator: SearchCoordinator?
  private let searchUseCase: SearchUseCase

  var type: FilterCase?
  
  init(coordinator: SearchCoordinator?, searchUseCase: SearchUseCase) {
    self.coordinator = coordinator
    self.searchUseCase = searchUseCase
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
    let didSelectItemAt: Signal<(FilterItem, IndexPath)>
  }
  
  struct Output {
    var data: Driver<[FilterSubSection]>
  }
  
  var disposeBag = DisposeBag()
  
  var data = BehaviorRelay<[FilterSubSection]>(value: [])

  func transform(input: Input) -> Output {
    let rawData = getSectionModel(type: type!)
    data.accept(rawData)
    
    input.didSelectItemAt
      .emit { (model, index) in
        print(model, index)
      }
      .disposed(by: disposeBag)
    
    return Output(
      data: data.asDriver()
    )
  }
}

extension FilterSubViewModel {
  func getSectionModel(type: FilterCase) -> [FilterSubSection] {
    switch type {
    case .environment(let env, let exp):
      var firstSectionitems: [FilterItem] = []
      if let env = env {
        firstSectionitems = getSectionModelItems(filterCase: env)
      } else {
        firstSectionitems = Environment.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      var secondSectionitems: [FilterItem] = []
      if let exp = exp {
        secondSectionitems = getSectionModelItems(filterCase: exp)
      } else {
        secondSectionitems = Experience.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      return [
        FilterSubSection(header: "주변환경", items: firstSectionitems),
        FilterSubSection(header: "자연활동", items: secondSectionitems)
      ]
    case .rule(let camptype, let resv):
      var firstSectionitems: [FilterItem] = []
      if let camptype = camptype {
        firstSectionitems = getSectionModelItems(filterCase: camptype)
      } else {
        firstSectionitems = CampType.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      var secondSectionitems: [FilterItem] = []
      if let resv = resv {
        secondSectionitems = getSectionModelItems(filterCase: resv)
      } else {
        secondSectionitems = ReservationType.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      return [
        FilterSubSection(header: "가능한 캠핑 유형", items: firstSectionitems),
        FilterSubSection(header: "예약방식", items: secondSectionitems)
      ]
    case .facility(let basicFctly, let sanitaryFctly, let sportsFctly):
      var firstSectionitems: [FilterItem] = []
      if let basicFctly = basicFctly {
        firstSectionitems = getSectionModelItems(filterCase: basicFctly)
      } else {
        firstSectionitems = BasicFacility.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      var secondSectionitems: [FilterItem] = []
      if let sanitaryFctly = sanitaryFctly {
        secondSectionitems = getSectionModelItems(filterCase: sanitaryFctly)
      } else {
        secondSectionitems = SanitaryFacility.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      var thirdSectionitems: [FilterItem] = []
      if let sportsFctly = sportsFctly {
        thirdSectionitems = getSectionModelItems(filterCase: sportsFctly)
      } else {
        thirdSectionitems = SportsFacility.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      return [
        FilterSubSection(header: "기본시설", items: firstSectionitems),
        FilterSubSection(header: "위생시설", items: secondSectionitems),
        FilterSubSection(header: "체육시설", items: thirdSectionitems),
      ]
    case .pet(let petEntry, let petSize):
      var firstSectionitems: [FilterItem] = []
      if let petEntry = petEntry {
        firstSectionitems = getSectionModelItems(filterCase: petEntry)
      } else {
        firstSectionitems = PetEnterType.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      var secondSectionitems: [FilterItem] = []
      if let petSize = petSize {
        secondSectionitems = getSectionModelItems(filterCase: petSize)
      } else {
        secondSectionitems = PetSize.allCases.map { FilterItem(title: $0.rawValue, selected: false) }
      }
      
      return [
        FilterSubSection(header: "입장", items: firstSectionitems),
        FilterSubSection(header: "입장 가능 사이즈", items: secondSectionitems)
      ]
    default:
      return []
    }
  }
  
  
  
  
  func getSectionModelItems<T: CaseIterable & Hashable & RawRepresentable>(filterCase: [T]) -> [FilterItem] {
    let oldSet = Set(filterCase)
    let newSet = Set(T.allCases).subtracting(oldSet)
    let selected = oldSet.map { FilterItem(title: $0.rawValue as! String, selected: true) }
    let unselected = newSet.map { FilterItem(title: $0.rawValue as! String, selected: false) }
    return selected + unselected
  }
}
