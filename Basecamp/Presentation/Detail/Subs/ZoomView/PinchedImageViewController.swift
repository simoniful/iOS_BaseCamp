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
  private var pinchedImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()

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
  
  private func showWithAnimation() {
    UIView.animate(withDuration: 0.2) { [unowned self] in
      dimmedView.alpha = 0.6
    }
  }
 
  func dismissWithAnimation(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.2) { [unowned self] in
      dimmedView.alpha = 0.0
      pinchedImageView.transform = .identity
    } completion: { [unowned self] result in
      completion?()
      dismiss(animated: false)
    }
  }
  
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
    guard let parentVC = self.parentViewController else {
      return nil
    }
    let pinchVC = PinchedImageViewController()
    pinchVC.modalPresentationStyle = .overFullScreen
    parentVC.present(pinchVC, animated: false)
    pinchVC.setImage(originImageView.image)
    let convertedFrame = originImageView.convert(originImageView.bounds, to: pinchVC.view)
    pinchVC.setFrame(convertedFrame)
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
    var newScale = gesture.scale
    if newScale < minScale {
      newScale = minScale
    } else if newScale > maxScale {
      newScale = maxScale
    }
    let gesturePoint = gesture.location(in: originImageView)
    let pinchCenter = CGPoint(
      x: gesturePoint.x - originImageView.bounds.midX,
      y: gesturePoint.y - originImageView.bounds.midY)
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
    vc.dismissWithAnimation() {
      originImageView.alpha = 1
    }
  }
  
  private func panGestureChanged(_ gesture: UIPanGestureRecognizer, viewController: PinchedImageViewController?) {
    guard let vc = viewController else {
      return
    }
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
