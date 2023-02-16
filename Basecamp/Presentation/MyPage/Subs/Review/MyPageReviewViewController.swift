//
//  MyPageReviewViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/13.
//

import UIKit
import RxSwift
import RxCocoa
import FSPagerView
import DropDown
import Kingfisher

final class MyPageReviewViewController: UIViewController {
  private let viewModel: MyPageReviewViewModel
  private var disposeBag = DisposeBag()
  
  private lazy var input = MyPageReviewViewModel.Input(
    viewWillAppear: self.rx.viewWillAppear.asObservable()
  )
  private lazy var output = viewModel.transform(input: input)
  
  private lazy var pagerView: FSPagerView = {
    let pagerView = FSPagerView()
    pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "ReviewPagerViewCell")
    pagerView.itemSize = FSPagerView.automaticSize
    pagerView.transformer = FSPagerViewTransformer(type: .linear)
    pagerView.isInfinite = false
    pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.7)
    pagerView.interitemSpacing = 10
    return pagerView
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
  }
}

extension MyPageReviewViewController: ViewRepresentable {
  func setupView() {
    
  }
  
  func setupConstraints() {
    
  }
}
