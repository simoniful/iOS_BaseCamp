//
//  YoutubeRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift

protocol YoutubeRepositoryInterface: AnyObject {
  func requestYoutubeInfoList(youtubeQueryType: YoutubeQueryType) -> Single<Result<[YoutubeInfo], YoutubeServiceError>>
}


