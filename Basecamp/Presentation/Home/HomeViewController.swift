//
//  HomeViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  lazy var rightBarSearchButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "magnifyingglass")
    barButton.style = .plain
    return barButton
  }()
  
  lazy var rightBarListButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "list.bullet")
    barButton.style = .plain
    return barButton
  }()
  
  lazy var rightBarMapButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.image = UIImage(systemName: "mappin.and.ellipse")
    barButton.style = .plain
    return barButton
  }()
  
  private let viewModel: HomeViewModel
  private let disposeBag = DisposeBag()
  
  private lazy var input = HomeViewModel.Input(
    viewDidLoad: Observable.just(Void()),
    viewWillAppear: self.rx.viewWillAppear.asObservable(),
    didSelectItemAt: self.collectionView.rx.modelAndIndexSelected(HomeItem.self).asSignal(),
    searchButtonDidTapped: rightBarSearchButton.rx.tap.asSignal(),
    listButtonDidTapped: rightBarListButton.rx.tap.asSignal(),
    mapButtonDidTapped: rightBarMapButton.rx.tap.asSignal()
  )
  
  private lazy var output = viewModel.transform(input: input)
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("HomeViewController: fatal error")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IndicatorView.shared.show(backgoundColor: .gray1.withAlphaComponent(0.4))
    bind()
    register()
    setupNavigationBar()
    setViews()
    setConstraints()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.collectionView.performBatchUpdates(nil, completion: nil)
  }
  
  func bind() {
    collectionView.collectionViewLayout = viewModel.createLayout()
    let dataSource = viewModel.dataSource()
    
    output.data
      .do(onNext: { _ in
        IndicatorView.shared.hide()
      })
      .drive(self.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

  }
}

private extension HomeViewController {
  private func setViews() {
    view.addSubview(collectionView)
  }
  
  private func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigationBar() {
    setupLogo()
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItems = [
      rightBarMapButton,
      rightBarListButton,
      rightBarSearchButton
    ]
  }
  
  func setupLogo() {
    let logoImage = UIImage.init(named: "logo")
    let logoImageView = UIImageView.init(image: logoImage)
    logoImageView.frame = CGRect(x: 0.0, y: 0.0,  width: 36, height: 36.0)
    logoImageView.contentMode = .scaleAspectFit
    let imageItem = UIBarButtonItem.init(customView: logoImageView)
    logoImageView.snp.makeConstraints {
      $0.width.height.equalTo(36)
    }
    navigationItem.leftBarButtonItem = imageItem
  }
  
  func register() {
    self.collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: HomeHeaderCell.identifier)
    self.collectionView.register(HomeAreaCell.self, forCellWithReuseIdentifier: HomeAreaCell.identifier)
    self.collectionView.register(HomeCampsiteCell.self, forCellWithReuseIdentifier: HomeCampsiteCell.identifier)
    self.collectionView.register(HomeFestivalCell.self, forCellWithReuseIdentifier: HomeFestivalCell.identifier)
    self.collectionView.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeader.identifier)
  }
}

