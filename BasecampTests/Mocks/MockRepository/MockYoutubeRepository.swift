//
//  MockYoutubeRepository.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/25.
//

import Foundation
import RxSwift
import RxCocoa
@testable import Basecamp

final class StubYoutubeRepository: YoutubeRepositoryInterface {
  func requestYoutubeInfoList(youtubeQueryType: YoutubeQueryType) -> Single<Result<[YoutubeInfo], YoutubeServiceError>> {
    switch youtubeQueryType {
    case .basic(let keyword, _):
      return Single.just(.success([
        YoutubeInfo(
          type: "youtube",
          title: keyword,
          url: "https://www.youtube.com/results?search_query=\(keyword)",
          description: "YouTube 검색 결과창으로 이동",
          thumbnailUrl: ""
        )
      ]))
    }
  }
}
