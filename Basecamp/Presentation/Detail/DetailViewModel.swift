//
//  DetailViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import RxCocoa

// 스타일에 따른 다른 데이터 소스/레이아웃 구성
enum DetailStyle {
  case campsite(campsite: Campsite)
  case touristInfo(touristInfo :TouristInfo)
}

final class DetailViewModel: ViewModel {
  private weak var coordinator: Coordinator?
  private let detailUseCase: DetailUseCase
  private let style: DetailStyle
  
  init(coordinator: Coordinator?, detailUseCase: DetailUseCase, style: DetailStyle) {
    self.coordinator = coordinator
    self.detailUseCase = detailUseCase
    self.style = style
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
  }
  
  struct Output {
    
  }
  
  private let aroundCellAction = PublishRelay<(DetailItem, IndexPath)>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    switch style {
    case .campsite(let campsite):
      let campsiteImageResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestCampsiteImageList(
            numOfRows: 30, pageNo: 1, contentId: campsite.contentID!
          )
        }
      
      let campsiteImageValue = campsiteImageResult
        .compactMap { data -> [String]? in
          self.detailUseCase.getCampsiteImageValue(data)
        }
      
      let campsiteImageError = campsiteImageResult
        .compactMap { data -> String? in
          self.detailUseCase.getCampsiteImageError(data)
        }
      
      let campsiteValue = Observable.just(campsite)
      
      let headerValue = Observable.combineLatest(campsiteImageValue, campsiteValue) {
        images, campsite -> [DetailCampsiteHeaderItem] in
        self.detailUseCase.requestHeaderData(campsite: campsite, images: images)
      }
      
      let weatherResult = input.viewWillAppear
        .flatMapLatest { _ in
          <#code#>
        }

      
    case .touristInfo(let touristInfo):
      <#code#>
    }
    return Output()
  }
}
  
