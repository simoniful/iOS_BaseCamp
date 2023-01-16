//
//  FilterUseCase.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/14.
//

import Foundation
import RxSwift
import RxCocoa

final class FilterUseCase {
  private let realmRepository: RealmRepositoryInterface
  
  init(realmRepository: RealmRepositoryInterface) {
    self.realmRepository = realmRepository
  }
}
