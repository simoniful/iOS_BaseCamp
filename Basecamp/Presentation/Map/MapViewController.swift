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

final class MapViewController: UIViewController {
  private let naverMapView = NMFNaverMapView()

  private lazy var input = MapViewModel.Input(
    viewDidLoad: self.rx.viewWillAppear.asObservable()
  )
  private lazy var output = viewModel.transform(input: input)
  
  public let viewModel: MapViewModel
  private let disposeBag = DisposeBag()
  
  var markers = [NMFMarker]()
  var centerMarkers = [NMFMarker]()
  
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
      .drive { campsites in
        DispatchQueue.global(qos: .default).async {
          var markers = [NMFMarker]()
          for campsite in campsites {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: Double(campsite.mapY!)!, lng: Double(campsite.mapX!)!)
            marker.iconImage = NMF_MARKER_IMAGE_YELLOW
            marker.captionText = campsite.facltNm!
            marker.minZoom = 10.0

            markers.append(marker)
          }
          
          DispatchQueue.main.async { [weak self] in
            for marker in markers {
              marker.mapView = self?.naverMapView.mapView
            }
          }
        }
      }
      .disposed(by: disposeBag)

  }
  

}

extension MapViewController: ViewRepresentable {
  func setupView() {
    [naverMapView].forEach {
      view.addSubview($0)
    }
  }
  
  func setupConstraints() {
    naverMapView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupAttribute() {
    naverMapView.mapView.mapType = .basic
    naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)
    naverMapView.mapView.addCameraDelegate(delegate: self)
    naverMapView.mapView.zoomLevel = 5.75
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 36.38 , lng: 127.51))
    naverMapView.mapView.moveCamera(cameraUpdate)
    naverMapView.mapView.minZoomLevel = 5.75
    naverMapView.mapView.maxZoomLevel = 18
    naverMapView.showZoomControls = false
    naverMapView.showLocationButton = true
    naverMapView.mapView.isTiltGestureEnabled = false
    naverMapView.mapView.isRotateGestureEnabled = false
  }
  
  
}

extension MapViewController: NMFMapViewCameraDelegate {
  
}
