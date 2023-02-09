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
import GoogleMaps
import GoogleMapsUtils
import Kingfisher

final class POIItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var campsite: Campsite

  init(position: CLLocationCoordinate2D, campsite: Campsite) {
    self.position = position
    self.campsite = campsite
  }
}

final class MapViewController: UIViewController {
  private lazy var mapView = GMSMapView(frame: .zero)
  private var clusterManager: GMUClusterManager!
  
  private lazy var filterButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    button.tintColor = .black
    button.backgroundColor = .white
    button.layer.cornerRadius = 8.0
    button.layer.borderWidth = 1.0
    button.layer.shadowColor = UIColor.gray.cgColor
    button.layer.shadowOpacity = 1.0
    button.layer.shadowOffset = CGSize.zero
    button.layer.shadowRadius = 2
    button.clipsToBounds = true
    return button
  }()
  
  private lazy var input = MapViewModel.Input(
    viewDidLoad: self.rx.viewWillAppear.asObservable()
  )
  private lazy var output = viewModel.transform(input: input)
  
  
  public let viewModel: MapViewModel
  private let disposeBag = DisposeBag()
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  func bind() {
    output.data
      .subscribe { [weak self] campsites in
        self?.generateClusterItems(by: campsites)
      }
      .disposed(by: disposeBag)
  }
  
  func generateClusterItems(by campsites: [Campsite]) {
    for campsite in campsites {
      guard let latitude = Double(campsite.mapY),
            let longitude = Double(campsite.mapX) else { return }
      let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let item = POIItem(position: position, campsite: campsite)
      clusterManager.add(item)
    }
    clusterManager.cluster()
  }
  
  func showPopup(campsite: Campsite) {
    let url = URL(string: campsite.firstImageURL)!
    let resource = ImageResource(downloadURL: url)
    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
      switch result {
      case .success(let value):
        self.view.makeToast(
          campsite.addr1, duration: 5.0,
          position: .bottom,
          title: campsite.facltNm, image: value.image
        ) { didTap in
          if didTap {
            self.viewModel.coordinator?.showDetailViewController(data: .campsite(data: campsite))
          } else {
            print("completion without tap")
          }
        }
      case .failure(_):
        self.view.makeToast(
          campsite.addr1, duration: 5.0,
          position: .bottom,
          title: campsite.facltNm, image: UIImage(named: "logoNoback")
        ) { didTap in
          if didTap {
            self.viewModel.coordinator?.showDetailViewController(data: .campsite(data: campsite))
          } else {
            print("completion without tap")
          }
        }
      }
    }
  }
}

extension MapViewController: ViewRepresentable {
  func setupView() {
    [mapView, filterButton].forEach {
      view.addSubview($0)
    }
  }
  
  func setupConstraints() {
    mapView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    filterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.width.height.equalTo(44.0)
    }
  }
  
  func setupAttribute() {
    let camera = GMSCameraPosition(latitude: 36.38, longitude: 127.51, zoom: 5.75)
    mapView.moveCamera(.setCamera(camera))
    mapView.mapType = .normal
    mapView.isIndoorEnabled = false
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
    mapView.settings.compassButton = true
    mapView.settings.tiltGestures = false
    mapView.settings.rotateGestures = false
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
    clusterManager.setMapDelegate(self)
  }
}

extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapView.animate(toLocation: marker.position)
    if marker.userData is GMUCluster {
      mapView.animate(toZoom: mapView.camera.zoom + 1)
      NSLog("Did tap cluster")
      return true
    }
    guard let poi = marker.userData as? POIItem else { return false }
    print(poi.campsite.facltNm)
    return false
  }
}
