//
//  SearchHeaderViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/15.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchHeaderViewModel {
  let sortButtonTapped = PublishRelay<Void>()
}
