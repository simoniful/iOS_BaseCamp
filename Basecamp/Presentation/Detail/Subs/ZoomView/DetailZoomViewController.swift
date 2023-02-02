//
//  DetailZoomViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/01.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailZoomViewController: UIViewController {
  weak var coordinator: DetailCoordinator?
  public var data: String?

  var disposeBag = DisposeBag()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.isUserInteractionEnabled = true
    imageView.bindPinchZoomGesture(maxScale: 4.0 ,disposedBy: disposeBag)
    return imageView
  }()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(closeDetailZoom), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    
    guard let data = data else { return }
    let processor = DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 4 * 3))
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(
      with: URL(string: data),
      options: [
        .processor(processor),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
  }
  
  @objc func closeDetailZoom(_ sender: UIButton) {
    self.dismiss(animated: true)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}

extension DetailZoomViewController: ViewRepresentable {
  func setupView() {
    view.addSubview(imageView)
    view.addSubview(closeButton)
    view.backgroundColor = .focus
  }
  
  func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width)
      $0.height.equalTo(imageView.snp.width).multipliedBy(0.75)
    }
    
    closeButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalTo(view.safeAreaLayoutGuide)
      $0.width.equalTo(44.0)
      $0.height.equalTo(44.0)
    }
  }
}


