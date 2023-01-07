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
  private lazy var weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.text = "주소"
    label.font = .title1M16
    label.numberOfLines = 0
    return label
  }()
  private let directionLabel: UILabel = {
    let label = UILabel()
    label.text = "찾아오는 길: 문의처에 문의 바랍니다."
    label.font = .body3R14
    label.numberOfLines = 0
    return label
  }()
  
  private var weatherData: [WeatherInfo] = [] {
    didSet {
      weatherCollectionView.reloadData()
    }
  }
  
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
    [weatherCollectionView, mapView, addressLabel, directionLabel].forEach {
      contentView.addSubview($0)
    }
    
    weatherCollectionView.register(DetailLocationWeatherCell.self, forCellWithReuseIdentifier: DetailLocationWeatherCell.identifier)
    weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    weatherCollectionView.collectionViewLayout = createLayout()
    weatherCollectionView.delegate = self
    weatherCollectionView.dataSource = self
  }
  
  func setupConstraints() {
    mapView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
    
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom).offset(8.0)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    directionLabel.snp.makeConstraints {
      $0.top.equalTo(addressLabel.snp.bottom)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    weatherCollectionView.snp.makeConstraints {
      $0.top.equalTo(directionLabel.snp.bottom).offset(8.0)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(100)
      $0.bottom.equalToSuperview()
    }
  }
  
  func setupData(data: DetailLocationItem) {
    weatherCollectionView.performBatchUpdates {
      addressLabel.text = data.address
      directionLabel.text = data.direction == "" ? "찾아오는 길: 문의처에 문의 바랍니다." : data.direction
      weatherData = data.weatherInfos
    }
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
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.18), heightDimension:.estimated(100.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      return section
    }
    return layout
  }
}

extension DetailLocationCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return weatherData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLocationWeatherCell.identifier, for: indexPath) as? DetailLocationWeatherCell else { return UICollectionViewCell() }
    cell.setupData(weatherInfo: weatherData[indexPath.item])
    return cell
  }
  
  
}


