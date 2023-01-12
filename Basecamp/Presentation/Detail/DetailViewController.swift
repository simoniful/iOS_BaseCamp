//
//  DetailViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation
import RxDataSources

final class DetailViewController: UIViewController {
  private let name: String
  private let locationManager = CLLocationManager()
  private let layoutManager = DetailViewSectionLayoutManager()
  private let isAutorizedLocation = PublishRelay<Bool>()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  lazy var rightBarShareButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "square.and.arrow.up")
    barButton.style = .plain
    return barButton
  }()
  
  lazy var rightBarDropDownButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "ellipsis")
    barButton.style = .plain
    return barButton
  }()
  
  let viewModel: DetailViewModel
  private let disposeBag = DisposeBag()
  
  private lazy var input = DetailViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    isAutorizedLocation: isAutorizedLocation.asSignal()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: DetailViewModel, name: String) {
    self.viewModel = viewModel
    self.name = name
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    locationManager.delegate = self
    bind()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.collectionView.performBatchUpdates(nil, completion: nil)
  }
  
  func bind() {
    switch viewModel.style {
    case .campsite:
      collectionView.collectionViewLayout = layoutManager.createCampsiteLayout()
      let dataSource = campsiteDataSource()
      output.data
        .drive(self.collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
      
      output.confirmAuthorizedLocation
        .emit(onNext: { [weak self] _ in
          let auth = self?.locationManager.authorizationStatus
          let status = auth == .authorizedAlways || auth == .authorizedWhenInUse
          self?.isAutorizedLocation.accept(status)
        })
        .disposed(by: disposeBag)
      
      output.updateLocationAction
        .emit(onNext: { [weak self] _ in
          self?.locationManager.startUpdatingLocation()
        })
        .disposed(by: disposeBag)
      
      output.unAutorizedLocationAlert
        .emit(onNext: { [weak self] (title, message) in
          guard let self = self else { return }
          let alert = AlertView.init(title: title, message: message) {
            self.moveToPhoneSetting()
          }
          alert.showAlert()
        })
        .disposed(by: disposeBag)
      
    case .touristInfo:
      print("뷰컨에서 불리는가?")
      output.confirmAuthorizedLocation
        .emit(onNext: { [weak self] _ in
          let auth = self?.locationManager.authorizationStatus
          let status = auth == .authorizedAlways || auth == .authorizedWhenInUse
          self?.isAutorizedLocation.accept(status)
        })
        .disposed(by: disposeBag)
      
      output.updateLocationAction
        .emit(onNext: { [weak self] _ in
          self?.locationManager.startUpdatingLocation()
        })
        .disposed(by: disposeBag)
      
      output.unAutorizedLocationAlert
        .emit(onNext: { [weak self] (title, message) in
          guard let self = self else { return }
          let alert = AlertView.init(title: title, message: message) {
            self.moveToPhoneSetting()
          }
          alert.showAlert()
        })
        .disposed(by: disposeBag)
    }
  }
}


extension DetailViewController: ViewRepresentable {
  func setupView() {
    setupNavigationBar()
    register()
    view.addSubview(collectionView)
  }
  
  func setupConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    navigationController?.navigationBar.topItem?.title = ""
    navigationItem.title = name
    navigationItem.rightBarButtonItems = [
      rightBarShareButton,
      rightBarDropDownButton
    ]
  }
  
  private func moveToPhoneSetting() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  func register() {
    self.collectionView.register(DetailCampsiteHeaderCell.self, forCellWithReuseIdentifier: DetailCampsiteHeaderCell.identifier)
    self.collectionView.register(DetailLocationCell.self, forCellWithReuseIdentifier: DetailLocationCell.identifier)
    self.collectionView.register(DetailFacilityCell.self, forCellWithReuseIdentifier: DetailFacilityCell.identifier)
    self.collectionView.register(DetailCampsiteInfoCell.self, forCellWithReuseIdentifier: DetailCampsiteInfoCell.identifier)
    self.collectionView.register(DetailSocialCell.self, forCellWithReuseIdentifier: DetailSocialCell.identifier)
    self.collectionView.register(DetailAroundCell.self, forCellWithReuseIdentifier: DetailAroundCell.identifier)
    self.collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)
    self.collectionView.register(DetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier)
  }
  
  func campsiteDataSource() -> RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel> {
    let dataSource = RxCollectionViewSectionedReloadDataSource<DetailCampsiteSectionModel>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath.section] {
        case .headerSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCampsiteHeaderCell.identifier, for: indexPath) as? DetailCampsiteHeaderCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          cell.viewModel(item: item)
            .bind(to: self.viewModel.headerAction)
            .disposed(by: self.disposeBag)
          return cell
        case .locationSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLocationCell.identifier, for: indexPath) as? DetailLocationCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .facilitySection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailFacilityCell.identifier, for: indexPath) as? DetailFacilityCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .infoSection(items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCampsiteInfoCell.identifier, for: indexPath) as? DetailCampsiteInfoCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .socialSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSocialCell.identifier, for: indexPath) as? DetailSocialCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        case .aroundSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAroundCell.identifier, for: indexPath) as? DetailAroundCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.parent = self
          cell.setupData(data: item)
          return cell
        case .imageSection(header: _, items: let items):
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
            return UICollectionViewCell()
          }
          let item = items[indexPath.row]
          cell.setupData(data: item)
          return cell
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch dataSource[indexPath.section] {
        case .headerSection,
            .infoSection:
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath)
          return header
        case .locationSection(header: let headerStr, _),
            .facilitySection(header: let headerStr, _),
            .socialSection(header: let headerStr, _),
            .aroundSection(header: let headerStr, _),
            .imageSection(header: let headerStr, _):
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier, for: indexPath) as? DetailSectionHeader else { return UICollectionReusableView() }
          header.setData(header: headerStr)
          return header
        }
      }
    )
    return dataSource
  }
}

extension DetailViewController: CLLocationManagerDelegate {
  
  func checkUserLocationServicesAuthorization() {
    let authorizationStatus: CLAuthorizationStatus
    if #available(iOS 14.0, *) {
      authorizationStatus = locationManager.authorizationStatus
    } else {
      authorizationStatus = CLLocationManager.authorizationStatus()
    }
    DispatchQueue.global().async {
      if CLLocationManager.locationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
          self.checkCurrentLocationAuthorization(authorizationStatus)
        } else {
          print("iOS 위치 서비스를 켜주세요")
          self.isAutorizedLocation.accept(false)
        }
      }
    }
  }
  
  func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
    switch authorizationStatus {
    case .notDetermined:
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    case .restricted, .denied:
      print("Denied, 설정 유도")
      isAutorizedLocation.accept(false)
    case .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
    case .authorizedAlways:
      print("Always")
    @unknown default:
      print("Default")
    }
    
    if #available(iOS 14.0, *) {
      let accurancyState = locationManager.accuracyAuthorization
      switch accurancyState {
      case .fullAccuracy:
        print("Full")
      case .reducedAccuracy:
        print("Reduce")
      @unknown default:
        print("Default")
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(#function)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print(#function)
    checkUserLocationServicesAuthorization()
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print(#function)
    checkUserLocationServicesAuthorization()
  }
}
