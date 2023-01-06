//
//  YoutubeRepository.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxSwift
import Moya
import RxMoya

enum YoutubeServiceError: Error {
  case serviceError
  case unknownError
}

final class YoutubeRepository: YoutubeRepositoryInterface {
  func requestYoutubeInfoList(youtubeQueryType: YoutubeQueryType) -> Single<Result<[YoutubeInfo], YoutubeServiceError>> {
    switch youtubeQueryType {
    case .basic(keyword: let keyword, _):
      let query = youtubeQueryType.query
      let requestDTO = YoutubeRequestDTO(query: query)
      let target = MultiTarget(YoutubeTarget.getYoutube(parameters: requestDTO.toDictionary))
      
      return provider.rx.request(target)
        .filterSuccessfulStatusCodes()
        .flatMap { response ->  Single<Result<[YoutubeInfo], YoutubeServiceError>> in
          let responseDTO = try response.map(YoutubeResponseDTO.self)
          return Single.just(Result.success(responseDTO.toDomain(keyword: keyword)))
        }
        .catch { error in
          return Single.just(Result.failure(.unknownError))
        }
    }
  }
}
