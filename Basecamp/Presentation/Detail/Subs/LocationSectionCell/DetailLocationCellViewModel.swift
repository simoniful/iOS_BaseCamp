//
//  DetailLocationCellViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/10.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailLocationCellViewModel {
  let isAutorizedLocation = PublishRelay<Bool>()
}
