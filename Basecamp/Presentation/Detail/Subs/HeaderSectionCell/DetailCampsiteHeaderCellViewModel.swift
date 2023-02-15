//
//  DetailCampsiteHeaderCellViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailCampsiteHeaderCellViewModel {
  let likeButtonDidTapped: PublishRelay<Void>
  let visitButtonDidTapped: PublishRelay<Void>
  let reservationButtonDidTapped: PublishRelay<Void>
  let callButtonDidTapped: PublishRelay<Void>
  let pagerViewDidTapped: PublishRelay<String>
  let isLiked: BehaviorRelay<Bool>
}
