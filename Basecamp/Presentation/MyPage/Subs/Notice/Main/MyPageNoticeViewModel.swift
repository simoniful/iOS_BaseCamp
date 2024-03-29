//
//  MyPageNoticeViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageNoticeViewModel: ViewModel {
  private weak var coordinator: MyPageCoordinator?
  
  var disposeBag = DisposeBag()
  
  init(coordinator: MyPageCoordinator?) {
    self.coordinator = coordinator
  }
  
  struct Input {
    let viewDidLoad: Signal<Void>
    let didSelectItemAt: Signal<(Notice, IndexPath)>
  }
  
  struct Output {
    let data: Driver<[Notice]>
  }
  
  let data = BehaviorRelay<[Notice]>(value: NoticeStorage.notices)
  
  func transform(input: Input) -> Output {
    input.didSelectItemAt
      .withUnretained(self)
      .emit { owner, item in
        let (notice, _) = item
         owner.coordinator?.showSubNoticeViewController(notice: notice)
      }
      .disposed(by: disposeBag)
    
    
    return Output(data: data.asDriver(onErrorJustReturn: []))
  }
}

struct Notice {
  let title: String
  let content: String
  let type: NoticeType
  let regDate: Date
}

enum NoticeType {
  case notice
  case patchNote
}

final class NoticeStorage {
  static let notices = [
    Notice(
      title: "1.0 버전 패치 노트",
      content: """
      <구현된 기능>
        ･ 캠핑장 검색 - 키워드, 필터 사용 상세 검색
        ･ 지역 정보 - 근처 캠핑장 및 관광정보 관련 카테고리화
        ･ 캠핑장 지도 - 클러스터를 통한 지역 캠핑장 확인
        ･ 개인화 서비스 - 캠핑로그 작성, 선호 캠핑장 등록
      
      <구현 예정 기능>
        ･ 캠핑 일정 등록 및 알림
        ･ 개인화를 위한 백업 기능
      """,
      type: .patchNote,
      regDate: "20230214".toDate()!
    ),
    Notice(
      title: "캠핑장 검색 서비스 BaseCamping 오픈",
      content: """
      안녕하세요.
      
      2023 다양한 캠핑장 정보, 관광 문화 정보를 원하는 캠퍼 여러분,
      BaseCamping을 이용해주셔서 감사합니다.
      
      좋은 정보와 경험을 제공하기 위해서 항상 개선하고 보완하는 앱이 되겠습니다.
      감사합니다.
      """,
      type: .notice,
      regDate: "20230214".toDate()!
    )
  ]
}
