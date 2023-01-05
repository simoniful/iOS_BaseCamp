//
//  DetailLocationCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NMapsMap
import CoreLocation

final class DetailLocationCell: UICollectionViewCell {
  static let identifier = "DetailLocationCell"
  private let locationManager = CLLocationManager()
  
  private lazy var mapView = NMFMapView()
  private lazy var weatherTableView = UITableView(frame: .zero, style: .plain)
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.text = "주소"
    label.font = .display1R20
    label.numberOfLines = 0
    return label
  }()
  private let directionLabel: UILabel = {
    let label = UILabel()
    label.text = "찾아오는 길: 문의처에 문의 바랍니다."
    label.font = .display1R20
    label.numberOfLines = 0
    return label
  }()
  
  private let isAutorizedLocation = PublishRelay<Bool>()
  
  override func layoutSubviews() {
      super.layoutSubviews()
      setupView()
      setupConstraints()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DetailLocationCell: ViewRepresentable {
  func setupView() {
    [mapView, weatherTableView, addressLabel, directionLabel].forEach {
      addSubview($0)
    }
  }
  
  func setupConstraints() {
    mapView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalTo(weatherTableView.snp.leading).offset(-16.0)
      $0.height.equalTo(mapView.snp.width).multipliedBy(1.0)
    }
    
    weatherTableView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.bottom.equalTo(mapView.snp.bottom)
    }
    
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom).offset(8.0)
      $0.trailing.equalToSuperview().offset(16.0)
      $0.leading.equalToSuperview().offset(-16.0)
    }
    
    directionLabel.snp.makeConstraints {
      $0.top.equalTo(addressLabel.snp.bottom).offset(8.0)
      $0.trailing.equalToSuperview().offset(16.0)
      $0.leading.equalToSuperview().offset(-16.0)
      $0.bottom.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(data: DetailLocationItem) {
    
  }
  
  func setMapView() {
      mapView.addCameraDelegate(delegate: self)
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      updateMyLocation()
  }
  
  func updateMyLocation() {
      let authorization = self.locationManager.authorizationStatus
      if authorization == .authorizedAlways || authorization == .authorizedWhenInUse {
          self.isAutorizedLocation.accept(true)
          locationManager.startUpdatingLocation()
      }
  }
}


extension DetailLocationCell: NMFMapViewCameraDelegate {
  func mapViewCameraIdle(_ mapView: NMFMapView) {
      print("mapViewCameraIdle-->")
      print("가운데 좌표 :", mapView.cameraPosition.target)
//      let centerCoordi = mapView.cameraPosition.target
//      requestOnqueueInfo.accept(Coordinate(latitude: centerCoordi.lat, longitude: centerCoordi.lng))
  }
}


extension DetailLocationCell: CLLocationManagerDelegate {
  func getLocationUsagePermission() {
      self.locationManager.requestWhenInUseAuthorization()
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
          print("GPS 권한 설정됨")
          self.locationManager.startUpdatingLocation()
      case .restricted, .notDetermined:
          print("GPS 권한 설정되지 않음")
          getLocationUsagePermission()
      case .denied:
          print("GPS 권한 요청 거부됨")
          getLocationUsagePermission()
      default:
          print("GPS: Default")
      }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location: CLLocation = locations[locations.count - 1]
      let longtitude: CLLocationDegrees = location.coordinate.longitude
      let latitude: CLLocationDegrees = location.coordinate.latitude
      let coordi = NMGLatLng(lat: latitude, lng: longtitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coordi)
      cameraUpdate.animation = .easeIn
      mapView.moveCamera(cameraUpdate)
      locationManager.stopUpdatingLocation()
  }
}


