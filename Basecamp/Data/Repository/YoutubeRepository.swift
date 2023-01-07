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
      
      // 실제로 스테이터 코드 분기를 통한 에러 핸들링 필요
      return provider.rx.request(target)
        .filterSuccessfulStatusCodes()
        .flatMap { response ->  Single<Result<[YoutubeInfo], YoutubeServiceError>> in
          print(response.statusCode, "리스폰스 코드 확인")
          let responseDTO = try response.map(YoutubeResponseDTO.self)
          return Single.just(Result.success(responseDTO.toDomain(keyword: keyword)))
        }
        .catchAndReturn(.success([
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
