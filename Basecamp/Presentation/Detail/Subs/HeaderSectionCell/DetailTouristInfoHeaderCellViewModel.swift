//
//  DetailTouristInfoHeaderCellViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailTouristInfoHeaderCellViewModel {
  let reservationButtonDidTapped: PublishRelay<Void>
  let callButtonDidTapped: PublishRelay<Void>
  let pagerViewDidTapped: PublishRelay<String>
}
