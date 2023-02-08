//
//  MapViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/29.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import NMapsMap
import NaverMapClusterFramework

final class MapViewController: UIViewController {
  struct Marker: markerProtocol {
    var markerName: String = ""
    var latitude: CGFloat = 0.0
    var longitude: CGFloat = 0.0
    
    var markerHandler: (() -> ())?
  }
  
  private let naverMapView = NMFNaverMapView()
  private var mapView: NMFMapView { naverMapView.mapView }
  private lazy var filterButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    button.tintColor = .black
    button.backgroundColor = .white
    button.layer.cornerRadius = 8.0
    button.layer.shadowColor = UIColor.gray.cgColor
    button.layer.shadowOpacity = 1.0
    button.layer.shadowOffset = CGSize.zero
    button.layer.shadowRadius = 6
    button.clipsToBounds = true
    return button
  }()
  
  private lazy var input = MapViewModel.Input(
    viewDidLoad: self.rx.viewWillAppear.asObservable()
  )
  private lazy var output = viewModel.transform(input: input)
  
  
  public let viewModel: MapViewModel
  private let disposeBag = DisposeBag()
  var clusterManager: ClusterManager?
  
  init(viewModel: MapViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    setupAttribute()
    bind()
  }
  
  func bind() {
    output.data
      .subscribe { [weak self] campsites in
        self?.generateClusterItems(by: campsites)
        self?.clusterManager!.cluster()
      }
      .disposed(by: disposeBag)
  }
  
  func generateClusterItems(by campsites: [Campsite]) {
    for campsite in campsites {
      let name = campsite.facltNm
      guard let lat = Double(campsite.mapY),
            let lng = Double(campsite.mapX) else { return }
      let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
      let item = ClusterItem.init()
      item.markerInfo = Marker.init(markerName: name, latitude: lat, longitude: lng, markerHandler: { [weak self] in
        NSLog("클릭클릭 \(lat) - \(lng)")
      })
      item.position = position
      clusterManager!.add(item)
    }
  }
}

extension MapViewController: ViewRepresentable {
  func setupView() {
    [naverMapView, filterButton].forEach {
      view.addSubview($0)
    }
  }
  
  func setupConstraints() {
    naverMapView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    filterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.width.height.equalTo(44.0)
    }
  }
  
  func setupAttribute() {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 36.38 , lng: 127.51))
    naverMapView.mapView.mapType = .basic
    naverMapView.mapView.positionMode = .normal
    naverMapView.mapView.addCameraDelegate(delegate: self)
    naverMapView.mapView.zoomLevel = 5.75
    naverMapView.mapView.moveCamera(cameraUpdate)
    naverMapView.mapView.logoAlign = .leftTop
    naverMapView.showZoomControls = false
    naverMapView.showLocationButton = false
    naverMapView.mapView.isTiltGestureEnabled = false
    naverMapView.mapView.isRotateGestureEnabled = false
    clusterManager = ClusterManager.init(mapView: self.naverMapView)
  }
}

extension MapViewController: NMFMapViewCameraDelegate {
  func mapViewCameraIdle(_ mapView: NMFMapView) {
    print(mapView.zoomLevel)
  }
}
