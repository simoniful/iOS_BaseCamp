//
//  RxCLLocationManagerDelegateProxy.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/30.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
  
  static func registerKnownImplementations() {
    self.register { locationManager -> RxCLLocationManagerDelegateProxy in
      RxCLLocationManagerDelegateProxy(parentObject: locationManager, delegateProxy: self)
    }
  }
  
  static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
    object.delegate
  }
  
  static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
    object.delegate = delegate
  }
  
  internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
  internal lazy var didFailWithErrorSubject = PublishSubject<Error>()
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
    didUpdateLocationsSubject.onNext(locations)
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    _forwardToDelegate?.locationManager(manager, didFailWithError: error)
    didFailWithErrorSubject.onNext(error)
  }
  
  deinit {
    self.didUpdateLocationsSubject.on(.completed)
    self.didFailWithErrorSubject.on(.completed)
  }
}
