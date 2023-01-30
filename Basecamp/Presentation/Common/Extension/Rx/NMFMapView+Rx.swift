//
//  NMFMapView+Rx.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/30.
//

import Foundation
import RxSwift
import RxCocoa
import NMapsMap


extension Reactive where Base: NMFMapView {
  
  var touchDelegate: DelegateProxy<NMFMapView, NMFMapViewTouchDelegate> {
    return RxNMFMapViewTouchDelegateProxy.proxy(for: self.base)
  }
  
  var cameraDelegate: DelegateProxy<NMFMapView, NMFMapViewCameraDelegate> {
    return RxNMFMapViewCameraDelegateProxy.proxy(for: self.base)
  }
  
  var didTapMap: Observable<NMGLatLng> {
    return touchDelegate.methodInvoked(#selector(NMFMapViewTouchDelegate.mapView(_:didTapMap:point:)))
      .map { parameters in
        return parameters[1] as? NMGLatLng ?? NMGLatLng(lat: 0, lng: 0)
      }
  }
  
  var mapViewCameraIdle: Observable<Void> {
    return cameraDelegate.methodInvoked(#selector(NMFMapViewCameraDelegate.mapViewCameraIdle(_:)))
      .map { _ in
        return
      }
  }
}
