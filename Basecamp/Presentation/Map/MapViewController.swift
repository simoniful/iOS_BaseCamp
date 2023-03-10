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

final class MapViewController: UIViewController {
  private lazy var mapView = GMSMapView(frame: .zero)
  private var clusterManager: GMUClusterManager!
  
  private lazy var filterButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    button.tintColor = .black
    button.backgroundColor = .white
    button.layer.masksToBounds = false
    button.layer.cornerRadius = 8.0
    button.layer.borderWidth = 1.0
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOpacity = 0.6
    button.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    button.layer.shadowRadius = 3
    return button
  }()
  
  private lazy var input = MapViewModel.Input(
    viewDidLoad: Observable.just(Void()),
    viewWillAppear: self.rx.viewWillAppear.asSignal(),
    sortButtonTapped: filterButton.rx.tap.asSignal()
  )
  private lazy var output = viewModel.transform(input: input)
  
  private let viewModel: MapViewModel
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
      .drive { [weak self] campsites in
        self?.generateClusterItems(by: campsites)
        self?.clusterManager.cluster()
      }
      .disposed(by: disposeBag)
  }
  
  func generateClusterItems(by campsites: [Campsite]) {
    clusterManager.clearItems()
    for campsite in campsites {
      guard let latitude = Double(campsite.mapY),
            let longitude = Double(campsite.mapX) else { return }
      let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let item = POIItem(position: position, campsite: campsite)
      clusterManager.add(item)
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
      $0.top.equalTo(mapView.snp.top).offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.width.height.equalTo(44.0)
    }
  }
  
  func setupAttribute() {
    let camera = GMSCameraPosition(latitude: 36.38, longitude: 127.51, zoom: 6.75)
    mapView.moveCamera(.setCamera(camera))
    mapView.mapType = .normal
    mapView.isIndoorEnabled = false
    mapView.isMyLocationEnabled = true
    mapView.settings.compassButton = true
    mapView.settings.tiltGestures = false
    mapView.settings.rotateGestures = false
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    renderer.animatesClusters = false
    renderer.delegate = self
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
    clusterManager.setDelegate(self, mapDelegate: self)
  }
}

extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapView.animate(toLocation: marker.position)
    return false
  }
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    guard let poi = marker.userData as? POIItem else { return }
    self.viewModel.coordinator?.showDetailViewController(data: .campsite(data: poi.campsite))
  }
}

extension MapViewController: GMUClusterManagerDelegate {
  func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
    mapView.animate(toZoom: mapView.camera.zoom + 1)
    return false
  }
}

extension MapViewController: GMUClusterRendererDelegate {
  func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
    if marker.userData is POIItem {
      if let item = marker.userData as? POIItem {
        marker.icon = UIImage(named: "defaultMarker")?.resize(newWidth: 40.0)
        marker.title = item.campsite.facltNm
        marker.snippet = item.campsite.addr1
        marker.appearAnimation = .pop
      }
    }
    
    if marker.userData is GMUStaticCluster {
      if let staticCluster = marker.userData as? GMUStaticCluster {
        switch staticCluster.count {
        case 0..<50:
          marker.iconView = makeClusterMarker(staticCluster: staticCluster, size: .XS)
        case 50..<100:
          marker.iconView = makeClusterMarker(staticCluster: staticCluster, size: .S)
        case 100..<200:
          marker.iconView = makeClusterMarker(staticCluster: staticCluster, size: .M)
        case 200..<500:
          marker.iconView = makeClusterMarker(staticCluster: staticCluster, size: .L)
        case 500..<1000:
          marker.iconView = makeClusterMarker(staticCluster: staticCluster, size: .XL)
        default:
          marker.iconView = makeClusterMarker(staticCluster: staticCluster, size: .XXL)
        }
        marker.appearAnimation = .pop
      }
    }
  }

  func makeClusterMarker(staticCluster: GMUStaticCluster, size: ClusterSize) -> UIView {
    let customClusterMarker = CustomClusterMarker()
    customClusterMarker.setupData(count: staticCluster.count, corner: size.corner, color: size.color, font: .systemFont(ofSize: size.fontSize, weight: .bold))
    let view = size.containerView
    view.addSubview(customClusterMarker)
    customClusterMarker.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    return view
  }
}

final class POIItem: NSObject, GMUClusterItem {
  var position: CLLocationCoordinate2D
  var campsite: Campsite
  
  init(position: CLLocationCoordinate2D, campsite: Campsite) {
    self.position = position
    self.campsite = campsite
  }
}

enum ClusterSize: CGFloat {
  case XS = 5
  case S = 6
  case M = 7
  case L = 8
  case XL = 9
  case XXL = 10
  
  var corner: CGFloat {
    return self.rawValue * 4
  }
  
  var fontSize: CGFloat {
    return (self.rawValue + 2) * 2
  }
  
  var color: UIColor {
    switch self {
    case .XS:
      return .green
    case .S:
      return .greenGray
    case .M:
      return .mainWeak
    case .L:
      return .main
    case .XL:
      return .mainStrong
    case .XXL:
      return .error
    }
  }
  
  var containerView: UIView {
    return UIView(frame: CGRect(x: 0, y: 0, width: self.rawValue * 8, height: self.rawValue * 8))
  }
}
