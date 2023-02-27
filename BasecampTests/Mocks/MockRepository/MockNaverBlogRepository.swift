//
//  MockNaverBlogRepository.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/25.
//

import Foundation
import RxSwift
import RxCocoa
@testable import Basecamp

final class StubNaverBlogRepository: NaverBlogRepositoryInterface {
  func requestNaverBlogInfoList(naverBlogQueryType: NaverBlogQueryType) -> Single<Result<[NaverBlogInfo], NaverBlogServiceError>> {
    switch naverBlogQueryType {
    case .basic(let keyword, _):
      return Single.just(.success([
        NaverBlogInfo(
          type: "naverBlog",
          title: keyword,
          url: "https://section.blog.naver.com/Search/Post.naver?pageNo=1&rangeType=ALL&orderBy=sim&keyword=\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          description: "블로그 검색 결과창으로 이동")
      ]))
    }
  }
}
