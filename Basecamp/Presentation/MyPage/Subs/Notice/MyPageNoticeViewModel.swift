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
  
  let data = BehaviorRelay<[Notice]>(value: NoticeStorage.notices)
  
  struct Input {
    let viewDidLoad: Signal<Void>
    let didSelectItemAt: Signal<(Notice, IndexPath)>
  }
  
  struct Output {
    let data: Driver<[Notice]>
  }
  
  func transform(input: Input) -> Output {
    input.didSelectItemAt
      .withUnretained(self)
      .emit { owner, item in
        let (notice, indexPath) = item
        // owner.coordinator.
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
      
      <구현 예정 기능>
      
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
