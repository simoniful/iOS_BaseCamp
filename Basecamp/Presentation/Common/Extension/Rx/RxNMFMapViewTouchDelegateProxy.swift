//
//  RxNMFMapViewTouchDelegateProxy.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/30.
//

import Foundation
import RxSwift
import RxCocoa
import NMapsMap

class RxNMFMapViewTouchDelegateProxy: DelegateProxy<NMFMapView, NMFMapViewTouchDelegate>, DelegateProxyType, NMFMapViewTouchDelegate {
  
  static func registerKnownImplementations() {
    self.register { mapView -> RxNMFMapViewTouchDelegateProxy in
      RxNMFMapViewTouchDelegateProxy(parentObject: mapView, delegateProxy: self)
    }
  }
  
  static func currentDelegate(for object: NMFMapView) -> NMFMapViewTouchDelegate? {
    object.touchDelegate
  }
  
  static func setCurrentDelegate(_ delegate: NMFMapViewTouchDelegate?, to object: NMFMapView) {
    object.touchDelegate = delegate
  }
}
