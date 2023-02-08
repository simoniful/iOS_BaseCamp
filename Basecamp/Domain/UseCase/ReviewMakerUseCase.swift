//
//  ReviewMakerUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/08.
//

import Foundation

final class ReviewMakerUseCase {
  private let realmRepository: RealmRepositoryInterface

  init(
    realmRepository: RealmRepositoryInterface
  ) {
    self.realmRepository = realmRepository
  }

  // MARK: - 램 데이터베이스 레포 연결
  func requestSaveReview(review: Review) {
    realmRepository.saveReview(review: review)
  }
}
