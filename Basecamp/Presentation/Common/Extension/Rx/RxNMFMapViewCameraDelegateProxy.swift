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

class RxNMFMapViewCameraDelegateProxy: DelegateProxy<NMFMapView, NMFMapViewCameraDelegate>, DelegateProxyType, NMFMapViewCameraDelegate {
  
  private static weak var cameraDelegate: NMFMapViewCameraDelegate?
  
  static func registerKnownImplementations() {
    self.register { mapView -> RxNMFMapViewCameraDelegateProxy in
      RxNMFMapViewCameraDelegateProxy(parentObject: mapView, delegateProxy: self)
    }
  }
  
  static func currentDelegate(for object: NMFMapView) -> NMFMapViewCameraDelegate? {
    self.cameraDelegate
  }
  
  static func setCurrentDelegate(_ delegate: NMFMapViewCameraDelegate?, to object: NMFMapView) {
    switch delegate {
    case .none:
      guard let setDelegate = self.cameraDelegate else {
        break
      }
      object.removeCameraDelegate(delegate: setDelegate)
    case .some(let delegate):
      object.addCameraDelegate(delegate: delegate)
    }
    self.cameraDelegate = delegate
  }
}
