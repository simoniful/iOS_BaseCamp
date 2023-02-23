//
//  ObservableType.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/23.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
  func asDriverOnErrorJustComplete() -> Driver<Element> {
    return asDriver { error in
      return Driver.empty()
    }
  }
  
  func asSignalOnErrorJustComplete() -> Signal<Element> {
    return asSignal { error in
      return Signal.empty()
    }
  }
  
  func mapToVoid() -> Observable<Void> {
    return map { _ in }
  }
}
