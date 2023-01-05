//
//  NaverBlogRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift

protocol NaverBlogRepositoryInterface: AnyObject {
  func requestNaverBlogInfoList(naverBlogQueryType: NaverBlogQueryType) -> Single<Result<[NaverBlogInfo], NaverBlogServiceError>>
}
