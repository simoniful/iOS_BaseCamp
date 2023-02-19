//
//  MyPageReviewViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FSPagerView
import GoogleMaps
import GoogleMapsUtils
import DropDown

final class MyPageReviewViewController: UIViewController {
  private let viewModel: MyPageReviewViewModel
  private var disposeBag = DisposeBag()
  private lazy var input = MyPageReviewViewModel.Input(
    viewWillAppear: Observable.just(()),
    deleteAllButtonTapped:
      rightBarAllDeleteButton.rx.tap.asSignal()
  )
  private lazy var output = viewModel.transform(input: input)
  private var clusterManager: GMUClusterManager!
  
  private lazy var pagerView: FSPagerView = {
    let pagerView = FSPagerView()
    pagerView.register(UINib(nibName: "MyPageReviewCardCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ReviewPagerViewCell")
    pagerView.decelerationDistance = 2
    pagerView.transformer = FSPagerViewCustomTransformer(type: .linear)
    pagerView.isInfinite = false
    pagerView.itemSize = CGSize(
      width: UIScreen.main.bounds.width * 0.8,
      height: UIScreen.main.bounds.width * 0.8 * 1.777
    )
    return pagerView
  }()
  private lazy var mapView = GMSMapView(frame: .zero)
  private lazy var yearDropDownView = DropDownView()
  private lazy var yearDropDown = DropDown()
  private lazy var viewTypeDropDownView = DropDownView()
  private lazy var viewTypeDropDown = DropDown()
  private lazy var rightBarAllDeleteButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "trash.fill")
    barButton.style = .plain
    return barButton
  }()
  
  init(viewModel: MyPageReviewViewModel) {
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
    setupDropdownUI()
    setupDropdown()
    setupNavigationBar()
    bind()
  }
  
  func bind() {
    output.data
      .drive { [weak self] reviews in
        self?.pagerView.reloadData()
        if !(reviews.isEmpty) {
          self?.pagerView.setNeedsLayout()
          self?.pagerView.layoutIfNeeded()
          self?.pagerView.scrollToItem(at: 0, animated: true)
        }
        
        let campsites = reviews.map { $0.campsite }
        self?.generateClusterItems(by: campsites)
        self?.clusterManager.cluster()
      }
      .disposed(by: disposeBag)
    
    output.viewType
      .drive { [weak self] type in
        switch type {
        case .card:
          self?.pagerView.isHidden = false
          self?.mapView.isHidden = true
        case .map:
          self?.pagerView.isHidden = true
          self?.mapView.isHidden = false
        }
      }
      .disposed(by: disposeBag)
    
    output.selectAlert
      .emit { [weak self] (title, message, review) in
        guard let self = self else { return }
        let alert = AlertView.init(
          title: title,
          message: message,
          someCompletion: {
            self.viewModel.deleteConfirmTapped.accept(review)
            self.view.makeToast("삭제 완료!")
          },
          otherCompletion: {
            self.viewModel.showCampsiteTapped.accept(review)
          }
        )
        alert.showAlert()
      }
      .disposed(by: disposeBag)
    
    output.deleteAllAlert
      .emit { [weak self] (title, message) in
        guard let self = self else { return }
        let alert = AlertView.init(title: title, message: message, buttonStyle: .confirmAndCancel) {
          self.viewModel.deleteAllConfirmTapped.accept(Void())
          self.view.makeToast("정리 완료!")
        }
        alert.showAlert()
      }
      .disposed(by: disposeBag)
  }
  
  func loadImageFromDocuments(imageFolderName: String) -> UIImage? {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    
    if let directoryPath = path.first {
      let imageURL = URL(fileURLWithPath: directoryPath)
        .appendingPathComponent("images")
        .appendingPathComponent(imageFolderName)
        .appendingPathComponent("0")
      return UIImage(contentsOfFile: imageURL.path)
    }
    return nil
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

extension MyPageReviewViewController: ViewRepresentable {
  func setupView() {
    view.backgroundColor = .systemBackground
    
    [pagerView, mapView, yearDropDownView, viewTypeDropDownView].forEach {
      view.addSubview($0)
    }
    
    pagerView.dataSource = self
    pagerView.delegate = self

    yearDropDownView.selectButton.addTarget(self, action: #selector(yearDropDownClicked), for: .touchUpInside)
    viewTypeDropDownView.selectButton.addTarget(self, action: #selector(viewTypeDropdownClicked), for: .touchUpInside)
  }
  
  func setupConstraints() {
    viewTypeDropDownView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32.0)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
      $0.height.equalTo(36.0)
      $0.width.equalTo(88.0)
    }
    
    yearDropDownView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32.0)
      $0.trailing.equalTo(viewTypeDropDownView.snp.leading).offset(-16.0)
      $0.height.equalTo(36.0)
      $0.width.equalTo(66.0)
    }
    
    pagerView.snp.makeConstraints {
      $0.top.equalTo(viewTypeDropDownView.snp.bottom).offset(-44.0)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func setupNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItems = [
      rightBarAllDeleteButton
    ]
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

extension MyPageReviewViewController: FSPagerViewDataSource, FSPagerViewDelegate {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return viewModel.data.value.count
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ReviewPagerViewCell", at: index) as! MyPageReviewCardCell
    let review = viewModel.data.value[index]
    let image = loadImageFromDocuments(imageFolderName: "\(review._id)")
    cell.setupAttribute()
    cell.setupData(data: review, index: index, image: image!)
    return cell
  }
  
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    let review = self.viewModel.data.value[index]
    self.viewModel.didSelectItemAt.accept((review, index))
  }
}

extension MyPageReviewViewController {
  func setupDropdownUI() {
    [yearDropDownView, viewTypeDropDownView].forEach {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 8
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.gray4.cgColor
      $0.layer.masksToBounds = true
      $0.textField.text = "전체"
      $0.textField.font = .title3M14
      $0.iconImageView.tintColor = UIColor.gray
    }
     
    yearDropDown.dismissMode = .automatic
    viewTypeDropDown.dismissMode = .automatic
  }
  
  func setupDropdown() {
    yearDropDown.dataSource = YearState.allCases.map { $0.rawValue }
    yearDropDown.anchorView = self.yearDropDownView
    yearDropDown.bottomOffset = CGPoint(x: 0, y: 36.0)
    viewTypeDropDown.dataSource = ViewType.allCases.map { $0.rawValue }
    viewTypeDropDown.anchorView = self.viewTypeDropDownView
    viewTypeDropDown.bottomOffset = CGPoint(x: 0, y: 36.0)
    
    yearDropDown.selectionAction = { [weak self] (index, item) in
      self!.yearDropDownView.textField.text = item
      self!.yearDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
      self?.viewModel.yearState.accept(YearState(rawValue: item)!)
    }
    
    viewTypeDropDown.selectionAction = { [weak self] (index, item) in
      self!.viewTypeDropDownView.textField.text = item
      self!.viewTypeDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
      self?.viewModel.viewType.accept(ViewType(rawValue: item)!)
    }
    
    yearDropDown.cancelAction = { [weak self] in
      self!.yearDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
    }
    
    viewTypeDropDown.cancelAction = { [weak self] in
      self!.viewTypeDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.down")
    }
    
    yearDropDown.selectRow(at: 0)
    yearDropDown.selectionAction?(0, "2023")

    viewTypeDropDown.selectRow(at: 0)
    viewTypeDropDown.selectionAction?(0, "카드보기")
  }
  
  @objc func yearDropDownClicked(_ sender: Any) {
    if yearDropDown.isHidden {
      yearDropDown.show()
      self.yearDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.up")
    }
  }
  
  @objc func viewTypeDropdownClicked(_ sender: Any) {
    if viewTypeDropDown.isHidden {
      viewTypeDropDown.show()
      self.viewTypeDropDownView.iconImageView.image = UIImage.init(systemName: "chevron.up")
    }
  }
}

extension MyPageReviewViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapView.animate(toLocation: marker.position)
    return false
  }
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    guard let poi = marker.userData as? POIItem else { return }
    self.viewModel.coordinator?.showDetailViewController(data: .campsite(data: poi.campsite))
  }
}

extension MyPageReviewViewController: GMUClusterManagerDelegate {
  func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
    mapView.animate(toZoom: mapView.camera.zoom + 1)
    return false
  }
}

extension MyPageReviewViewController: GMUClusterRendererDelegate {
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
          let customClusterMarker = CustomClusterMarker()
          customClusterMarker.setupData(count: staticCluster.count, corner: 20, color: .green, font: .systemFont(ofSize: 14, weight: .bold))
          let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
          view.addSubview(customClusterMarker)
          customClusterMarker.snp.makeConstraints {
            $0.edges.equalToSuperview()
          }
          marker.iconView = view
        case 50..<100:
          let customClusterMarker = CustomClusterMarker()
          customClusterMarker.setupData(count: staticCluster.count, corner: 24, color: .greenGray, font: .systemFont(ofSize: 16, weight: .bold))
          let view = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
          view.addSubview(customClusterMarker)
          customClusterMarker.snp.makeConstraints {
            $0.edges.equalToSuperview()
          }
          marker.iconView = view
        case 100..<200:
          let customClusterMarker = CustomClusterMarker()
          customClusterMarker.setupData(count: staticCluster.count, corner: 28, color: .mainWeak, font: .systemFont(ofSize: 18, weight: .bold))
          let view = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
          view.addSubview(customClusterMarker)
          customClusterMarker.snp.makeConstraints {
            $0.edges.equalToSuperview()
          }
          marker.iconView = view
        case 200..<500:
          let customClusterMarker = CustomClusterMarker()
          customClusterMarker.setupData(count: staticCluster.count, corner: 32, color: .main, font: .systemFont(ofSize: 20, weight: .bold))
          let view = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
          view.addSubview(customClusterMarker)
          customClusterMarker.snp.makeConstraints {
            $0.edges.equalToSuperview()
          }
          marker.iconView = view
        case 500..<1000:
          let customClusterMarker = CustomClusterMarker()
          customClusterMarker.setupData(count: staticCluster.count, corner: 36, color: .mainStrong, font: .systemFont(ofSize: 20, weight: .bold))
          let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
          view.addSubview(customClusterMarker)
          customClusterMarker.snp.makeConstraints {
            $0.edges.equalToSuperview()
          }
          marker.iconView = view
        default:
          let customClusterMarker = CustomClusterMarker()
          customClusterMarker.setupData(count: staticCluster.count, corner: 40, color: .error, font: .systemFont(ofSize: 22, weight: .bold))
          let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
          view.addSubview(customClusterMarker)
          customClusterMarker.snp.makeConstraints {
            $0.edges.equalToSuperview()
          }
          marker.iconView = view
        }
        marker.appearAnimation = .pop
      }
    }
  }
}
