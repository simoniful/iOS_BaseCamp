//
//  DetailReviewPhotoSelectViewController.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/07.
//

import UIKit
import SnapKit
import FMPhotoPicker
import Toast_Swift

final class DetailReviewPhotoSelectViewController: UIViewController {
  private let viewModel: DetailReviewMakerViewModel

  private var selectedItems: [UIImage] = []
  
  private lazy var photoLabel = DefaultLabel(title: "배경 사진들을 선택해주세요", font: .systemFont(ofSize: 20, weight: .semibold), textAlignment: .left)
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "imagePlus")?.resize(newWidth: 20.0)
    imageView.contentMode = .center
    imageView.backgroundColor = .gray1
    imageView.tintColor = .darkGray
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 16.0
    return imageView
  }()
  
  private lazy var rightBarCompleteButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem()
    barButton.title = "저장"
    barButton.action = #selector(completeReview)
    barButton.target = self
    barButton.style = .plain
    barButton.tintColor = .main
    barButton.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.main,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .bold)
    ], for: .normal)
    return barButton
  }()
  
  init(viewModel: DetailReviewMakerViewModel) {
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
  }
}

extension DetailReviewPhotoSelectViewController: ViewRepresentable {
  func setupView() {
    [photoLabel, imageView].forEach {
      view.addSubview($0)
    }
    navigationItem.rightBarButtonItem = rightBarCompleteButton
  }
  
  func setupConstraints() {
    photoLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalTo(photoLabel.snp.bottom).offset(16.0)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(view.snp.width).multipliedBy(0.4)
      $0.height.equalTo(imageView.snp.width).multipliedBy(1.77)
    }
  }
  
  func setupAttribute() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
    imageView.addGestureRecognizer(tapGesture)
    imageView.isUserInteractionEnabled = true
  }
  
  @objc func touchToPickPhoto() {
    let vc = FMPhotoPickerViewController(config: config())
    vc.delegate = self
    self.present(vc, animated: true)
  }
  
  func config() -> FMPhotoPickerConfig {
    let selectMode: FMSelectMode = .multiple
    let mediaTypes: [FMMediaType] = [.image]
  
    var config = FMPhotoPickerConfig()
    
    config.selectMode = selectMode
    config.mediaTypes = mediaTypes
    config.maxImage = 5
    config.forceCropEnabled = true
    // config.eclipsePreviewEnabled = true
    
    // in force crop mode, only the first crop option is available
    config.availableCrops = [
      FMCrop.ratio9x16
    ]
    config.useCropFirst = true
    config.alertController = FMCustomAlert()
    
    // all available filters will be used
    config.availableFilters = []
    config.strings = [
      "picker_button_cancel":                     "취소",
      "picker_button_select_done":                "선택 완료",
      "picker_warning_over_image_select_format":  "최대 %d개의 이미지만 선택할 수 있습니다",
      "picker_warning_over_video_select_format":  "최대 %d개의 동영상만 선택할 수 있습니다",
      "present_title_photo_created_date_format":  "yyyy.MM.dd",
      "present_button_back":                      "뒤로",
      "present_button_edit_image":                "이미지 수정",
      "editor_button_cancel":                     "취소",
      "editor_button_done":                       "완료",
      "editor_menu_filter":                       "필터",
      "editor_menu_crop":                         "자르기",
      "editor_menu_crop_button_reset":            "원래대로",
      "editor_menu_crop_button_rotate":           "회전",
      "editor_crop_ratio4x3":                     "4:3",
      "editor_crop_ratio16x9":                    "16:9",
      "editor_crop_ratio9x16":                    "9x16",
      "editor_crop_ratioCustom":                  "커스텀",
      "editor_crop_ratioOrigin":                  "원본",
      "editor_crop_ratioSquare":                  "정방형",
      "permission_dialog_title":                  "사진첩 권한",
      "permission_dialog_message":                "해당 기능을 사용하기 위해 사진첩에 대한 접근 권한이 필요합니다",
      "permission_button_ok":                     "완료",
      "permission_button_cancel":                 "취소"
    ]
    return config
  }
  
  @objc func completeReview() {
    let alert = AlertView.init(title: "캠핑로그 저장", message: "해당 내용대로 캠핑로그를 저장하시겠습니까?", buttonStyle: .confirmAndCancel) {
      self.viewModel.selectedPhotos.accept(self.selectedItems)
      self.viewModel.saveReview()
      self.navigationController?.dismiss(animated: true)
    }
    alert.showAlert()
  }
}

extension DetailReviewPhotoSelectViewController: FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate {
  func fmImageEditorViewController(_ editor: FMPhotoPicker.FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
    self.dismiss(animated: true, completion: nil)
    imageView.contentMode = .scaleAspectFit
    imageView.image = photo
    selectedItems = [photo]
  }
  
  func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
    self.dismiss(animated: true, completion: nil)
    if let thumbnail = photos.first {
      imageView.contentMode = .scaleAspectFit
      imageView.image = thumbnail
    }
    selectedItems = photos
  }
}

struct FMCustomAlert: FMAlertable {
  func show(in viewController: UIViewController, ok: @escaping () -> Void, cancel: @escaping () -> Void) {
    let alert = UIAlertController(title: "작업을 취소하시겠습니까?", message: nil, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in ok() }))
    alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { _ in cancel() }))
    
    viewController.present(alert, animated: true, completion: nil)
  }
}

