//
//  UICollectionView+Rx.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UICollectionView {
  public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
    ControlEvent(events: Observable.zip(
      self.modelSelected(modelType),
      self.itemSelected
    ))
  }
}
