//
//  DetailViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

// 스타일에 따른 다른 데이터 소스/레이아웃 구성
enum DetailStyle {
  case campsite(campsite: Campsite)
  case touristInfo(touristInfo :TouristInfo)
}

final class DetailViewModel: ViewModel {
  private weak var coordinator: Coordinator?
  private let detailUseCase: DetailUseCase
  let style: DetailStyle
  
  init(coordinator: Coordinator?, detailUseCase: DetailUseCase, style: DetailStyle) {
    self.coordinator = coordinator
    self.detailUseCase = detailUseCase
    self.style = style
  }
  
  struct Input {
    let viewWillAppear: Observable<Void>
  }
  
  struct Output {
    let data: Driver<[DetailCampsiteSectionModel]>
  }
  
  let aroundTabmanViewModel = DetailAroundTabmanViewModel()
  
  private let data = PublishRelay<[DetailCampsiteSectionModel]>()
  
  var disposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    switch style {
    case .campsite(let campsite):
      // MARK: - Header Data
      let campsiteImageResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestCampsiteImageList(
            numOfRows: 30, pageNo: 1, contentId: campsite.contentID!
          )
        }
      
      let campsiteImageValue = campsiteImageResult
        .do(onNext: { data in
          print(data, "캠핑 이미지 데이터 패칭 ----")
        })
        .compactMap { data -> [String]? in
          self.detailUseCase.getValue(data)
        }
      
      let campsiteImageError = campsiteImageResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let headerValue = campsiteImageValue.map { images -> [DetailCampsiteHeaderItem] in
        self.detailUseCase.requestHeaderData(campsite: campsite, images: images)
      }
      
      // MARK: - Location Data
      let weatherResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestWeatherList(
            lat: Double(campsite.mapY!)!,
            lon: Double(campsite.mapX!)!
          )
        }
      
      let weatherValue = weatherResult
        .do(onNext: { data in
          print(data, "날씨 데이터 패칭 ----")
        })
        .compactMap { data -> [WeatherInfo]? in
          return self.detailUseCase.getValue(data)
        }
      
      let weatherError = weatherResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let locationValue = weatherValue.map { weatherData -> [DetailLocationItem] in
        self.detailUseCase.requestLocationData(campsite: campsite, weatherData: weatherData)
      }
      
      // MARK: - Facility Data
      let facilityValue = input.viewWillAppear
        .compactMap { _ in
          self.detailUseCase.requestFacilityData(campsite: campsite)
        }
      
      // MARK: - Info Data
      let infoValue = input.viewWillAppear
        .compactMap { _ in
          self.detailUseCase.requsetInfoData(campsite: campsite)
        }
      
      // MARK: - Social Data
      let naverBlogResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestNaverBlogInfoList(keyword: campsite.facltNm! ,display: 3)
        }

      let youtubeResult = input.viewWillAppear
        .flatMapLatest { _ in
          self.detailUseCase.requestYoutubeInfoList(keyword: campsite.facltNm!, maxResults: 3)
        }
      
      let naverBlogValue = naverBlogResult
        .do(onNext: { data in
          print(data, "네이버 데이터 패칭 ----")
        })
        .compactMap { data -> [NaverBlogInfo]? in
          self.detailUseCase.getValue(data)
        }
      
      let naverBlogError = naverBlogResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let youtubeValue = youtubeResult
        .do(onNext: { data in
          print(data, "유튜브 데이터 패칭 ----")
        })
        .compactMap { data -> [YoutubeInfo]? in
          self.detailUseCase.getValue(data)
        }
      
      let youtubeError = youtubeResult
        .compactMap { data -> String? in
          self.detailUseCase.getError(data)
        }
      
      let socialValue = Observable.combineLatest(naverBlogValue, youtubeValue) {
        naverBlog, youtube -> [DetailSocialItem] in
        self.detailUseCase.requestSocialData(youtubeData: youtube, naverBlogData: naverBlog)
      }
      
      // MARK: - Around Data
      let aroundValue = input.viewWillAppear
        .compactMap { _ in
          self.detailUseCase.requestAroundData(campsite:campsite)
        }
      
      // MARK: - Image Data
      let imageValue = campsiteImageValue
        .compactMap { data in
          self.detailUseCase.requestImageData(strings: data)
        }
      
      Observable.combineLatest(
        headerValue, locationValue,
        facilityValue, infoValue,
        socialValue, aroundValue,
        imageValue
      ) {
        header, location, facility, info, social, around, image -> [DetailCampsiteSectionModel] in
        print("데이터 패칭 완료")
        return self.detailUseCase.getDetailCampsiteSectionModel(header, location, facility, info, social, around, image)
      }
      .bind(to: data)
      .disposed(by: disposeBag)
      
    case .touristInfo(let touristInfo):
      break
    }
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
  
  
  
}


