//
//  PinchedImageViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class PinchedImageViewController: UIViewController {
  /// 확대된 이미지뷰
  private var pinchedImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  /// 뒷배경을 어둡게 하기 위한 뷰
  private var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showWithAnimation()
  }
  
  private func setupUI() {
    [dimmedView, pinchedImageView].forEach {
      view.addSubview($0)
    }
    dimmedView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  /// 뷰컨트롤러가 나타날 때 호출하며 배경을 점진적으로 어둡게 만든다.
  private func showWithAnimation() {
    UIView.animate(withDuration: 0.2) { [unowned self] in
      dimmedView.alpha = 0.6
    }
  }
  /// 이미지를 원래 상태로 되돌리고 배경을 투명하게 만든 뒤 뷰컨트롤러를 제거한다.
  func dismissWithAnimation(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.2) { [unowned self] in
      dimmedView.alpha = 0.0
      pinchedImageView.transform = .identity
    } completion: { [unowned self] result in
      completion?()
      dismiss(animated: false)
    }
  }
  
  /// 이미지 뷰의 위치와 크기를 조절하기 위한 프로퍼티
  var imageTransform: CGAffineTransform {
    get {
      pinchedImageView.transform
    }
    set {
      pinchedImageView.transform = newValue
    }
  }
  func setImage(_ image: UIImage?) {
    pinchedImageView.image = image
  }
  func setFrame(_ frame: CGRect) {
    pinchedImageView.frame = frame
  }
}

private weak var pinchViewController: PinchedImageViewController?

extension UIImageView {
  func bindPinchZoomGesture(minScale: CGFloat = 1.0, maxScale: CGFloat = 2.0, disposedBy disposeBag: DisposeBag) {
    self.rx.pinchGesture(configuration: { gesture, delegate in
      delegate.simultaneousRecognitionPolicy = .never
    })
    .subscribe(onNext: { [unowned self] gesture in
      switch gesture.state {
      case .began:
        pinchViewController = pinchGestureBegan(gesture, originImageView: self)
      case .changed:
        pinchGestureChanged(
          gesture, originImageView: self,
          minScale: minScale, maxScale: maxScale,
          viewController: pinchViewController)
      case .ended:
        pinchGestureEnded(
          gesture, originImageView: self,
          viewController: pinchViewController)
      default: break
      }
    }).disposed(by: disposeBag)
    
    self.rx.panGesture()
      .when(.changed)
      .subscribe(onNext: { [unowned self] gesture in
        panGestureChanged(gesture, viewController: pinchViewController)
      }).disposed(by: disposeBag)
  }
  
  
  private func pinchGestureBegan(_ gesture: UIPinchGestureRecognizer, originImageView: UIImageView) -> PinchedImageViewController? {
    // 핀치이미지뷰컨트롤러를 표시하기 위한 상위 뷰컨트롤러를 찾는다
    guard let parentVC = self.parentViewController else {
      return nil
    }
    let pinchVC = PinchedImageViewController()
    // 애니메이션 없이 VC를 바로 표시한다
    pinchVC.modalPresentationStyle = .overFullScreen
    parentVC.present(pinchVC, animated: false)
    
    // 이미지를 설정하고 크기를 뷰에 맞게 만든다
    pinchVC.setImage(originImageView.image)
    let convertedFrame = originImageView.convert(originImageView.bounds, to: pinchVC.view)
    pinchVC.setFrame(convertedFrame)
    // 기존의 이미지뷰는 잠시 가린다
    originImageView.alpha = 0
    
    return pinchVC
  }
  
  private func pinchGestureChanged(
    _ gesture: UIPinchGestureRecognizer,
    originImageView: UIImageView,
    minScale: CGFloat, maxScale: CGFloat,
    viewController: PinchedImageViewController?
  ) {
    guard let vc = viewController else { return }
    
    // 스케일 수치의 최소값 및 최대값을 제한한다
    var newScale = gesture.scale
    if newScale < minScale {
      newScale = minScale
    } else if newScale > maxScale {
      newScale = maxScale
    }
    // 제스쳐의 위치에 기반하여 뷰의 확대 축을 옮긴다
    let gesturePoint = gesture.location(in: originImageView)
    let pinchCenter = CGPoint(
      x: gesturePoint.x - originImageView.bounds.midX,
      y: gesturePoint.y - originImageView.bounds.midY)
    // 계산한 트랜스폼을 적용한다
    vc.imageTransform = CGAffineTransform(
      translationX: pinchCenter.x, y: pinchCenter.y)
    .scaledBy(x: newScale, y: newScale)
    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
  }
  
  private func pinchGestureEnded(
    _ gesture: UIPinchGestureRecognizer,
    originImageView: UIImageView,
    viewController: PinchedImageViewController?
  ) {
    guard let vc = viewController else { return }
    // 핀치이미지뷰컨트롤러를 제거하고 기존 이미지를 다시 표시한다
    vc.dismissWithAnimation() {
      originImageView.alpha = 1
    }
  }
  
  private func panGestureChanged(_ gesture: UIPanGestureRecognizer, viewController: PinchedImageViewController?) {
    guard let vc = viewController else {
      return
    }
    // 제스쳐의 위치를 기반으로 뷰의 위치를 변경해준다
    let point = gesture.translation(in: vc.view)
    vc.imageTransform = vc.imageTransform.translatedBy(x: point.x, y: point.y)
  }
}

extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self.next
    while parentResponder != nil {
      if let vc = parentResponder as? UIViewController {
        return vc
      }
      parentResponder = parentResponder?.next
    }
    return nil
  }
}
