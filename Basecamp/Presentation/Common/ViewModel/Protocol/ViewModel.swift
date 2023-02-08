//
//  ViewModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import Foundation
import RxSwift

protocol ViewModel {
  associatedtype Input
  associatedtype Output
  
  var disposeBag: DisposeBag { get set }
  func transform(input: Input) -> Output
}
