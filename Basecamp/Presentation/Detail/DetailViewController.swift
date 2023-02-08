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
  private let isAutorizedLocation = PublishRelay<Bool>()
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  private lazy var rightBarShareButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "square.and.arrow.up")
    barButton.style = .plain
    return barButton
  }()
  
  private lazy var rightBarDropDownButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "ellipsis")
    barButton.menu = dropDownMenu
    return barButton
  }()
  
  private lazy var dropDownMenuItems: [UIAction] = {
    switch viewModel.style {
    case .campsite(data: let data):
      return [
        UIAction(title: "전화", image: UIImage(systemName: "phone"), handler: { _ in
          self.viewModel.headerAction
            .accept(HeaderCellAction.call)
        }),
        UIAction(title: "예약", image: UIImage(systemName: "calendar"), handler: { _ in
          self.viewModel.headerAction
            .accept(HeaderCellAction.reserve)
        }),
        UIAction(title: "방문", image: UIImage(systemName: "flag"), handler: { _ in
          self.viewModel.headerAction
            .accept(HeaderCellAction.visit)
        }),
        UIAction(title: "찜", image: UIImage(systemName: "heart"), handler: { _ in
          self.viewModel.headerAction
            .accept(HeaderCellAction.like)
        })
      ]
    case .touristInfo(data: let data):
      return [
        UIAction(title: "전화", image: UIImage(systemName: "phone"), handler: { _ in
          self.viewModel.headerAction
            .accept(HeaderCellAction.call)
        }),
        UIAction(title: "예약", image: UIImage(systemName: "calendar"), handler: { _ in
          self.viewModel.headerAction
            .accept(HeaderCellAction.reserve)
        })
      ]
    }
  }()
  
  private lazy var dropDownMenu: UIMenu = {
    return UIMenu(title: "", options: [], children: dropDownMenuItems)
  }()
  
  let viewModel: DetailViewModel
  let disposeBag = DisposeBag()
  
  private lazy var input = DetailViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    isAutorizedLocation: isAutorizedLocation.asSignal(),
    didSelectItemAt: self.collectionView.rx.modelAndIndexSelected(DetailItem.self).asSignal(),
    shareButtonDidTapped: rightBarShareButton.rx.tap.asSignal()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: DetailViewModel) {
    self.viewModel = viewModel
    switch viewModel.style {
    case .campsite(data: let campsite):
      self.name = campsite.facltNm
    case .touristInfo(data: let touristInfo):
      self.name = touristInfo.title!
    }
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IndicatorView.shared.show(backgoundColor: .gray1.withAlphaComponent(0.4))
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
      collectionView.collectionViewLayout = DetailViewSectionLayoutManager.createCampsiteLayout()
      let dataSource = DetailViewDataSourceManager.campsiteDataSource(self)
      
      output.campsiteData
        .do(onNext: { _ in
          IndicatorView.shared.hide()
        })
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
      
      output.noUrlDataAlert
        .emit { [weak self] (title, message, keyword) in
          let alert = AlertView.init(title: title, message: message, buttonStyle: .confirmAndCancel) {
            guard let urlStr = "https://search.naver.com/search.naver?query=\(keyword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let url = URL(string: urlStr) else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
          alert.showAlert()
        }
        .disposed(by: disposeBag)
      
      output.callAlert
        .emit { (title, message, telNum) in
          let alert = AlertView.init(title: title, message: message, buttonStyle: .confirmAndCancel) {
            let telNum = telNum.replacingOccurrences(of: "-", with: "")
            let urlStr = "tel://\(telNum)"
            guard let url = URL(string: urlStr) else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
          alert.showAlert()
        }
        .disposed(by: disposeBag)
      
    case .touristInfo:
      collectionView.collectionViewLayout = DetailViewSectionLayoutManager.createTouristInfoLayout()
      
      let dataSource = DetailViewDataSourceManager.touristInfoDataSource(self)
      
      output.touristInfoData
        .do(onNext: { _ in
          IndicatorView.shared.hide()
        })
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
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
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
    self.collectionView.register(DetailTouristInfoHeaderCell.self, forCellWithReuseIdentifier: DetailTouristInfoHeaderCell.identifier)
    self.collectionView.register(DetailLocationCell.self, forCellWithReuseIdentifier: DetailLocationCell.identifier)
    self.collectionView.register(DetailFacilityCell.self, forCellWithReuseIdentifier: DetailFacilityCell.identifier)
    self.collectionView.register(DetailCampsiteInfoCell.self, forCellWithReuseIdentifier: DetailCampsiteInfoCell.identifier)
    self.collectionView.register(DetailTouristInfoIntroCell.self, forCellWithReuseIdentifier: DetailTouristInfoIntroCell.identifier)
    self.collectionView.register(DetailSocialCell.self, forCellWithReuseIdentifier: DetailSocialCell.identifier)
    self.collectionView.register(DetailAroundCell.self, forCellWithReuseIdentifier: DetailAroundCell.identifier)
    self.collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)
    self.collectionView.register(DetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier)
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
