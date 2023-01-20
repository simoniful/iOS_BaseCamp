//
//  FilterSubViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/16.
//

import Foundation
import RxSwift
import RxCocoa

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
    let didTapConfirmButton: Signal<Void>
  }
  
  struct Output {
    var data: Driver<[FilterSubSection]>
  }
  
  var disposeBag = DisposeBag()
  
  var data = BehaviorRelay<[FilterSubSection]>(value: [])

  func transform(input: Input) -> Output {
    let rawData = getSectionModel(type: type!)
    data.accept(rawData)
    
    input.didTapConfirmButton
      .withUnretained(self)
      .emit { (owner, _) in
        let filterCase = owner.dataToFilterCase(data: owner.data.value)
        owner.coordinator?.popToFilterMainViewController(message: "필터가 설정되었어요", filterCase: filterCase)
      }
      .disposed(by: disposeBag)

    return Output(
      data: data.asDriver()
    )
  }
}

extension FilterSubViewModel {
  func dataToFilterCase(data: [FilterSubSection]) -> FilterCase {
    switch type! {
    case .area:
      let areaSelected = data[0].items.filter{ $0.selected }
      let area: [Area]? = areaSelected.isEmpty ? nil : areaSelected.map({
        Area(rawValue: $0.title!)
      }) as? [Area]
      return FilterCase.area(area)
    case .environment:
      let envSelected = data[0].items.filter{ $0.selected }
      let expSelected = data[1].items.filter{ $0.selected }
      let env: [Environment]? = envSelected.isEmpty ? nil : envSelected.map({ Environment(rawValue: $0.title!) }) as? [Environment]
      let exp: [Experience]? = expSelected.isEmpty ? nil : expSelected.map({ Experience(rawValue: $0.title!) }) as? [Experience]
      return FilterCase.environment(env, exp)
    case .rule:
      let camptypeSelected = data[0].items.filter{ $0.selected }
      let resvSelected = data[1].items.filter{ $0.selected }
      let camptype: [CampType]? = camptypeSelected.isEmpty ? nil : camptypeSelected.map({ CampType(rawValue: $0.title!) }) as? [CampType]
      let resv: [ReservationType]? = resvSelected.isEmpty ? nil : resvSelected.map({ ReservationType(rawValue: $0.title!) }) as? [ReservationType]
      return FilterCase.rule(camptype, resv)
    case .facility:
      let basicFctlySelected = data[0].items.filter{ $0.selected }
      let sanitaryFctlySelected = data[1].items.filter{ $0.selected }
      let sportsFctlySelected = data[2].items.filter{ $0.selected }
      let basicFctly: [BasicFacility]? = basicFctlySelected.isEmpty ? nil : basicFctlySelected.map({ BasicFacility(rawValue: $0.title!) }) as? [BasicFacility]
      let sanitaryFctly: [SanitaryFacility]? = sanitaryFctlySelected.isEmpty ? nil : sanitaryFctlySelected.map({ SanitaryFacility(rawValue: $0.title!) }) as? [SanitaryFacility]
      let sportsFctly: [SportsFacility]? = sportsFctlySelected.isEmpty ? nil : sportsFctlySelected.map({ SportsFacility(rawValue: $0.title!) }) as? [SportsFacility]
      return FilterCase.facility(basicFctly, sanitaryFctly, sportsFctly)
    case .pet:
      let petEntrySelected = data[0].items.filter{ $0.selected }
      let petSizeSelected = data[1].items.filter{ $0.selected }
      let petEntry: [PetEnterType]? = petEntrySelected.isEmpty ? nil : petEntrySelected.map({ PetEnterType(rawValue: $0.title!) }) as? [PetEnterType]
      let petSize: [PetSize]? = petSizeSelected.isEmpty ? nil : petSizeSelected.map({ PetSize(rawValue: $0.title!) }) as? [PetSize]
      return FilterCase.pet(petEntry, petSize)
    }
  }
  
  func getSectionModel(type: FilterCase) -> [FilterSubSection] {
    switch type {
    case .area(let area):
      let firstSectionitems = getSectionModelItems(filterCase: area)
      
      return [
        FilterSubSection(header: "캠핑장 위치", items: firstSectionitems)
      ]
      
    case .environment(let env, let exp):
      let firstSectionitems = getSectionModelItems(filterCase: env)
      let secondSectionitems = getSectionModelItems(filterCase: exp)
      
      return [
        FilterSubSection(header: "주변환경", items: firstSectionitems),
        FilterSubSection(header: "자연활동", items: secondSectionitems)
      ]
    case .rule(let camptype, let resv):
      let firstSectionitems = getSectionModelItems(filterCase: camptype)
      let secondSectionitems = getSectionModelItems(filterCase: resv)
      
      return [
        FilterSubSection(header: "가능한 캠핑 유형", items: firstSectionitems),
        FilterSubSection(header: "예약방식", items: secondSectionitems)
      ]
    case .facility(let basicFctly, let sanitaryFctly, let sportsFctly):
      let firstSectionitems = getSectionModelItems(filterCase: basicFctly)
      let secondSectionitems = getSectionModelItems(filterCase: sanitaryFctly)
      let thirdSectionitems = getSectionModelItems(filterCase: sportsFctly)
      
      return [
        FilterSubSection(header: "기본시설", items: firstSectionitems),
        FilterSubSection(header: "위생시설", items: secondSectionitems),
        FilterSubSection(header: "체육시설", items: thirdSectionitems),
      ]
    case .pet(let petEntry, let petSize):
      let firstSectionitems = getSectionModelItems(filterCase: petEntry)
      let secondSectionitems = getSectionModelItems(filterCase: petSize)
      
      return [
        FilterSubSection(header: "입장", items: firstSectionitems),
        FilterSubSection(header: "입장 가능 사이즈", items: secondSectionitems)
      ]
    }
  }
  
  func getSectionModelItems<T: CaseIterable & Hashable & RawRepresentable>(filterCase: [T]?) -> [FilterItem] {
    var resultItems: [FilterItem] = []
    if let filterCase = filterCase {
      let oldSet = Set(filterCase)
      let newSet = Set(T.allCases).subtracting(oldSet)
      let selected = oldSet.map { FilterItem(title: $0.rawValue as? String, selected: true) }
      let unselected = newSet.map { FilterItem(title: $0.rawValue as? String, selected: false) }
      resultItems = selected + unselected
    } else {
      resultItems = T.allCases.map { FilterItem(title: $0.rawValue as? String, selected: false) }
    }
    return resultItems
  }
}
