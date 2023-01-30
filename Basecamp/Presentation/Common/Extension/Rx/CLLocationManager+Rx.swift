//
//  CLLocationManager+Rx.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/30.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


extension Reactive where Base: CLLocationManager {
  /**
   Reactive wrapper for `delegate`.
   For more information take a look at `DelegateProxyType` protocol documentation.
   */
  var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
    return RxCLLocationManagerDelegateProxy.proxy(for: self.base)
  }
  
  
  // MARK: Responding to Location Events - 위치관련 이벤트에 응답
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didUpdateLocations: Observable<[CLLocation]> {
    RxCLLocationManagerDelegateProxy.proxy(for: base).didUpdateLocationsSubject.asObservable()
  }

  /**
   Reactive wrapper for `delegate` message.
   */
  public var didFailWithError: Observable<Error> {
    RxCLLocationManagerDelegateProxy.proxy(for: base).didFailWithErrorSubject.asObservable()
  }
  
#if os(iOS) || os(macOS)
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didFinishDeferredUpdatesWithError: Observable<Error?> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFinishDeferredUpdatesWithError:)))
      .map { parameters in
        return try castOptionalOrThrow(Error.self, parameters[1])
      }
  }
#endif
  
#if os(iOS)
  
  // MARK: Pausing Location Updates 위치정보 업데이트 일시정지 관련
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didPauseLocationUpdates: Observable<Void> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidPauseLocationUpdates(_:)))
      .map { _ in
        return ()
      }
  }
  
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didResumeLocationUpdates: Observable<Void> {
    return delegate.methodInvoked( #selector(CLLocationManagerDelegate.locationManagerDidResumeLocationUpdates(_:)))
      .map { _ in
        return ()
      }
  }
  
  // MARK: Responding to Heading Events 방향 이벤트에 대한 응답
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didUpdateHeading: Observable<CLHeading> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateHeading:)))
      .map { parameters in
        return try castOrThrow(CLHeading.self, parameters[1])
      }
  }
  
  // MARK: Responding to Region Events 지역 이벤트에 대한 응답
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didEnterRegion: Observable<CLRegion> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didEnterRegion:)))
      .map { parameters in
        return try castOrThrow(CLRegion.self, parameters[1])
      }
  }
  
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didExitRegion: Observable<CLRegion> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didExitRegion:)))
      .map { parameters in
        return try castOrThrow(CLRegion.self, parameters[1])
      }
  }
  
#endif
  
#if os(iOS) || os(macOS)
  
  /**
   Reactive wrapper for `delegate` message.
   */
  @available(OSX 10.10, *)
  public var didDetermineStateForRegion: Observable<(state: CLRegionState, region: CLRegion)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didDetermineState:for:)))
      .map { parameters in
        let stateNumber = try castOrThrow(NSNumber.self, parameters[1])
        let state = CLRegionState(rawValue: stateNumber.intValue) ?? CLRegionState.unknown
        let region = try castOrThrow(CLRegion.self, parameters[2])
        return (state: state, region: region)
      }
  }
  
  /**
   Reactive wrapper for `delegate` message.
   */
  public var monitoringDidFailForRegionWithError: Observable<(region: CLRegion?, error: Error)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:monitoringDidFailFor:withError:)))
      .map { parameters in
        let region = try castOptionalOrThrow(CLRegion.self, parameters[1])
        let error = try castOrThrow(Error.self, parameters[2])
        return (region: region, error: error)
      }
  }
  
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didStartMonitoringForRegion: Observable<CLRegion> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didStartMonitoringFor:)))
      .map { parameters in
        return try castOrThrow(CLRegion.self, parameters[1])
      }
  }
  
#endif
  
#if os(iOS)
  
  // MARK: Responding to Ranging Events 범위 이벤트에 대한 응답
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didRangeBeaconsSatisfyingConstraint: Observable<(beacons: [CLBeacon], constraint: CLBeaconIdentityConstraint)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didRange:satisfying:)))
      .map { parameters in
        let beacons = try castOrThrow([CLBeacon].self, parameters[1])
        let constraint = try castOrThrow(CLBeaconIdentityConstraint.self, parameters[2])
        return (beacons: beacons, constraint: constraint)
      }
  }
  
  /**
   Reactive wrapper for `delegate` message.(deprecated)
   */
  public var didRangeBeaconsInRegion: Observable<(beacons: [CLBeacon], region: CLBeaconRegion)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didRangeBeacons:in:)))
      .map { parameters in
        let beacons = try castOrThrow([CLBeacon].self, parameters[1])
        let region = try castOrThrow(CLBeaconRegion.self, parameters[2])
        return (beacons: beacons, region: region)
      }
  }
  
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didFailRangingBeaconsForConstraintWithError: Observable<(constraint: CLBeaconIdentityConstraint, error: Error)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailRangingFor:error:)))
      .map { parameters in
        let constraint = try castOrThrow(CLBeaconIdentityConstraint.self, parameters[1])
        let error = try castOrThrow(Error.self, parameters[2])
        return (constraint: constraint, error: error)
      }
  }
  
  /**
   Reactive wrapper for `delegate` message.(deprecated)
   */
  public var rangingBeaconsDidFailForRegionWithError: Observable<(region: CLBeaconRegion, error: Error)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:rangingBeaconsDidFailFor:withError:)))
      .map { parameters in
        let region = try castOrThrow(CLBeaconRegion.self, parameters[1])
        let error = try castOrThrow(Error.self, parameters[2])
        return (region: region, error: error)
      }
  }
  
  // MARK: Responding to Visit Events 방문이벤트에 대한 응답
  /**
   Reactive wrapper for `delegate` message.
   */
  @available(iOS 8.0, *)
  public var didVisit: Observable<CLVisit> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didVisit:)))
      .map { parameters in
        return try castOrThrow(CLVisit.self, parameters[1])
      }
  }
  
#endif
  
  // MARK: Responding to Authorization Changes 권한 변경에 대한 응답
  /**
   Reactive wrapper for `delegate` message.
   */
  public var didChangeAuthorizationStatus: Observable<Void> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:)))
      .map { _ in
        return ()
      }
  }
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
  guard let returnValue = object as? T else {
    throw RxCocoaError.castingError(object: object, targetType: resultType)
  }
  
  return returnValue
}

private func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
  if NSNull().isEqual(object) {
    return nil
  }
  
  guard let returnValue = object as? T else {
    throw RxCocoaError.castingError(object: object, targetType: resultType)
  }
  
  return returnValue
}
